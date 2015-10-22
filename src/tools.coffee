Promise = require 'bluebird'
DatacenterManager = require './datacenterManager'
RestClient = require './basicCommunication/rest-client'
utils = require './utils'

class DatacenterToolbox
    constructor: (@datacenterName) ->
        @dcManager = new DatacenterManager()
        @restClient = null

    startAllServers: Promise.coroutine () ->
        yield @_ensureInitialization()

        servers = yield @restClient.listServers()
        for server in servers
            yield @restClient.startServer(server.id)

        yield @restClient.waitTillOpenTasksHaveFinished()

    stopAllServers: Promise.coroutine () ->
        yield @_ensureInitialization()

        servers = yield @restClient.listServers()
        for server in servers
            yield @restClient.stopServer(server.id)

        yield @restClient.waitTillOpenTasksHaveFinished()

    _ensureInitialization: Promise.coroutine ->
        unless @_inititalized()
            yield @_initialize()

    _initialize: Promise.coroutine ->
        datacenter = yield @dcManager.findDatacenter @datacenterName
        @restClient = RestClient @dcManager.getBasicClient(), datacenter.id

    _inititalized: ->
        return @restClient?

module.exports = DatacenterToolbox
