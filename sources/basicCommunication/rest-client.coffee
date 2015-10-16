Promise = require 'bluebird'
utils = require('../utils')

module.exports = (basicClient, datacenterId) ->
    service = {}

    service.getDatacenter = Promise.coroutine ->
        route = "datacenters/#{datacenterId}?depth=5"
        return yield basicClient.get route

    service.listLans = Promise.coroutine ->
        route = "datacenters/#{datacenterId}/lans?depth=5"
        return yield basicClient.getCollection route

    service.createLan = Promise.coroutine (data) ->
        route = "datacenters/#{datacenterId}/lans?depth=5"
        return yield basicClient.post route, data

    service.updateLan = Promise.coroutine (data, lanId) ->
        route = "datacenters/#{datacenterId}/lans/#{lanId}?depth=5"
        return yield basicClient.patch route, data

    service.listServers = Promise.coroutine ->
        route = "datacenters/#{datacenterId}/servers?depth=5"
        return yield basicClient.getCollection route

    service.getServer = Promise.coroutine (serverId) ->
        route = "datacenters/#{datacenterId}/servers/#{serverId}?depth=5"
        return yield basicClient.get route

    service.createServer = Promise.coroutine (data) ->
        route = "datacenters/#{datacenterId}/servers?depth=5"
        return yield basicClient.post route, data

    service.deleteServer = Promise.coroutine (serverId) ->
        route = "datacenters/#{datacenterId}/servers/#{serverId}"
        return yield basicClient.delete route

    service.patchServer = Promise.coroutine (serverId, data) ->
        route = "datacenters/#{datacenterId}/servers/#{serverId}"
        return yield basicClient.patch route, data

    service.startServer = Promise.coroutine (serverId) ->
        route = "datacenters/#{datacenterId}/servers/#{serverId}/start"
        return yield basicClient.post route

    service.stopServer = Promise.coroutine (serverId) ->
        route = "datacenters/#{datacenterId}/servers/#{serverId}/stop"
        return yield basicClient.post route

    service.rebootServer = Promise.coroutine (serverId) ->
        route = "datacenters/#{datacenterId}/servers/#{serverId}/reboot"
        return yield basicClient.post route

    service.listVolumes = Promise.coroutine  ->
        route = "datacenters/#{datacenterId}/volumes?depth=1"
        return yield basicClient.getCollection route

    service.createVolume = Promise.coroutine (data) ->
        route = "datacenters/#{datacenterId}/volumes"
        return yield basicClient.post route, data

    service.deleteVolume = Promise.coroutine (volumeId) ->
        route = "datacenters/#{datacenterId}/volumes/#{volumeId}"
        return yield basicClient.delete route

    service.attachVolume = Promise.coroutine (serverId, volumeId) ->
        route = "datacenters/#{datacenterId}/servers/#{serverId}/volumes"
        return yield basicClient.post route, {id: volumeId}

    service.waitTillOpenTasksHaveFinished = Promise.coroutine ->
        yield basicClient.waitTillOpenTasksHaveFinished()

    return service
