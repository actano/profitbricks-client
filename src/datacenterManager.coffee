Promise = require 'bluebird'

BasicClient = require('./basicCommunication/basicClient')
utils = require('./utils')

module.exports = (user = process.env['PROFITBRICKS_USER'],
                  password = process.env['PROFITBRICKS_PASSWORD']) ->

    basicClient = BasicClient user, password
    service = {}

    service.getBasicClient = ->
        return basicClient

    service.listDatacenters = Promise.coroutine ->
        route = 'datacenters?depth=1'
        return yield basicClient.getCollection route

    service.findDatacenter = Promise.coroutine (name) ->
        datacenters = yield @listDatacenters()
        return utils.getItemByName 'Datacenter', datacenters, name

    service.hasDatacenter = Promise.coroutine (name) ->
        datacenters = yield @listDatacenters()
        return utils.getItemsByName(datacenters, name).length > 0

    service.createDatacenter = Promise.coroutine (data) ->
        datacenters = yield @listDatacenters()
        utils.itemWithThisNameAlreadyExistsGuard 'Datacenter', datacenters, data.properties.name

        datacenter = yield _createDatacenter data
        yield basicClient.waitTillOpenTasksHaveFinished()
        return datacenter

    service.deleteDatacenter = Promise.coroutine (name) ->
        datacenter = yield @findDatacenter name
        yield _deleteDatacenter datacenter.id
        yield basicClient.waitTillOpenTasksHaveFinished()

    service.deleteDatacenterIfExists = Promise.coroutine (name) ->
        try
            yield @deleteDatacenter name
        catch err
            console.log 'could not delete, because:'
            console.log err.message

    service.listSnapshots = Promise.coroutine ->
        route = 'snapshots?depth=5'
        return yield basicClient.getCollection route

    service.listImages = Promise.coroutine ->
        route = 'images?depth=5'
        return yield basicClient.getCollection route

    service.findImage = Promise.coroutine (name) ->
        images = yield @listImages()
        return utils.getItemByName 'Image', images, name

    service.findSnapshot = Promise.coroutine (name) ->
        snapshots = yield @listSnapshots()
        return utils.getItemByName 'Snapshot', snapshots, name

    service.findImageOrSnapshot = Promise.coroutine (name) ->
        images = yield @listImages()
        snapshots = yield @listSnapshots()
        return utils.getItemByName 'Image or Snapshot', images.concat(snapshots), name

    service.waitTillOpenTasksHaveFinished = Promise.coroutine ->
        yield basicClient.waitTillOpenTasksHaveFinished()

    _createDatacenter = Promise.coroutine (data) ->
        route = 'datacenters'
        return yield basicClient.post route, data

    _deleteDatacenter = Promise.coroutine (datacenterId) ->
        route = "datacenters/#{datacenterId}"
        yield basicClient.delete route

    return service



