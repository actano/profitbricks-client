Promise = require 'bluebird'
DatacenterManager = require './datacenterManager'
RestClient = require './basicCommunication/rest-client'
utils = require './utils'

class DatacenterCreator
    constructor: ->
        @dcManager = new DatacenterManager()
        @restClient = null

    createOrReplaceDatacenter: Promise.coroutine (datacenter) ->
        yield @dcManager.deleteDatacenterIfExists datacenter.getName()
        yield @createDatacenter datacenter

    createDatacenter: Promise.coroutine (datacenter) ->
        createdDatacenter = yield @dcManager.createDatacenter datacenter.toJson()
        @_initializeRestClient createdDatacenter.id

        yield @_addLans datacenter.getLans()
        yield @_addServers datacenter.getServers()

    addServersToDatacenter: Promise.coroutine (datacenter) ->
        remoteDatacenter = yield @dcManager.findDatacenter datacenter.getName()
        @_initializeRestClient remoteDatacenter.id
        yield @_addMissingServers datacenter.getServers()

    createLan: Promise.coroutine (lan) ->
        remoteLans = yield @restClient.listLans()
        utils.itemWithThisNameAlreadyExistsGuard 'LAN', remoteLans, lan.getName()

        @lans = null
        console.log "creating lan '#{lan.getName()}'"
        yield @restClient.createLan lan.toJson()
        yield @restClient.waitTillOpenTasksHaveFinished()

    createServer: Promise.coroutine (server) ->
        remoteServers = yield @restClient.listServers()
        utils.itemWithThisNameAlreadyExistsGuard 'Server', remoteServers, server.getName()

        # TODO: If more than one volume is needed: Implement it here
        console.log "creating volume for server '#{server.getName()}'"
        volume = yield @createVolume server.volumes[0]
        server.setBootVolumeId volume.id
        yield @_setLanIds server.getNics()

        console.log "creating server '#{server.getName()}'"
        yield @restClient.createServer server.toJson()
        yield @restClient.waitTillOpenTasksHaveFinished()

        return server

    createVolume: Promise.coroutine (volume) ->
        remoteVolumes = yield @restClient.listVolumes()
        utils.itemWithThisNameAlreadyExistsGuard 'Volume', remoteVolumes, volume.getName()

        imageOrSnapshot = yield @findImageOrSnapshot volume.getImageName()
        volume.setImageId imageOrSnapshot.id

        createdVolume = yield @restClient.createVolume volume.toJson()

        yield @restClient.waitTillOpenTasksHaveFinished()
        return createdVolume

    findLan: Promise.coroutine (name) ->
        unless @lans?
            @lans = yield @restClient.listLans()

        return utils.getItemByName 'LAN', @lans, name

    findImageOrSnapshot: Promise.coroutine (name) ->
        unless @imagesAndSnapshots?
            yield @_loadImagesAndSnapshots()

        return utils.getItemByName 'Image or Snapshot', @imagesAndSnapshots, name

    _initializeRestClient: (datacenterId) ->
        @restClient = RestClient @dcManager.getBasicClient(), datacenterId

    _loadImagesAndSnapshots: Promise.coroutine ->
        images = yield @dcManager.listImages()
        snapshots = yield @dcManager.listSnapshots()
        @imagesAndSnapshots = images.concat snapshots

    _addLans: Promise.coroutine (lans) ->
        for lan in lans
            yield @createLan lan

    _addServers: Promise.coroutine (servers) ->
        for server, index in servers
            console.log "server #{index+1}/#{servers.length}"
            yield @createServer server

    _addMissingServers: Promise.coroutine (definedServers) ->
        existingServers = yield @restClient.listServers()
        missingServers = @_calculateMissingServers definedServers, existingServers
        yield @_addServers missingServers

    _calculateMissingServers: (definedServers, existingServers) ->
        existingServerNames = existingServers.map (item) -> item.properties.name
        missingServers = definedServers.filter (item) -> existingServerNames.indexOf(item.getName()) < 0
        return missingServers

    _setLanIds: Promise.coroutine (nics) ->
        for nic in nics
            lan = yield @findLan nic.getName()
            nic.setLanId lan.id

module.exports = DatacenterCreator

