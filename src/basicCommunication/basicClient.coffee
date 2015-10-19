debug =
    request: require('debug')('pb-client-request')
    response: require('debug')('pb-client-response')

Promise = require 'bluebird'
request = require('superagent')
require('superagent-as-promised')(request)

TaskQueue = require('./taskQueue')

###
    This function provides the basic rest calls and takes care of
    Error Handling, Logging and Synchronization
###
module.exports = (user, password, sleepTimeBetweenStatusRequests = 2) ->
    if not user? or not password?
        throw new Error "no authentification provided"

    service = {}

    service.status = Promise.coroutine (url) ->
        try
            response = yield request.get(url).auth(user, password)
            return response.res.body.metadata
        catch err
            try
                response = err.response.res
                console.error "status polling failed - GET #{url}: #{response.statusCode} (#{response.statusMessage})\n#{response.text}"
            catch readingErrorError
                console.error "failed to parse status response - GET #{url}: #{err}"

    taskQueue = new TaskQueue service.status, sleepTimeBetweenStatusRequests

    service.get = Promise.coroutine (route) ->
        url = 'https://api.profitbricks.com/rest/' + route
        req = request.get url
        response = yield @sendRequest req, "GET #{route}"
        return response.body

    service.getCollection = Promise.coroutine (route) ->
        return (yield @get route).items

    service.post = Promise.coroutine (route, data) ->
        url = 'https://api.profitbricks.com/rest/' + route
        req = request.post(url)

        if data?
            req = req.set('Content-Type', 'application/vnd.profitbricks.resource+json')

        response = yield @sendRequest req, "POST #{route}", data
        return response.body

    service.patch = Promise.coroutine (route, data) ->
        url = 'https://api.profitbricks.com/rest/' + route

        req = request.patch(url).set('Content-Type', 'application/vnd.profitbricks.partial-properties+json')
        response = yield @sendRequest req, "PATCH #{route}", data

        return response.body

    service.delete = Promise.coroutine (route) ->
        url = 'https://api.profitbricks.com/rest/' + route
        req = request.del url
        yield @sendRequest req, "DELETE #{route}"

    service.sendRequest = Promise.coroutine (request, msg, data) ->
        request = request.auth(user, password)
        try
            console.info "> #{msg}"
            if data?
                debug.request JSON.stringify data, null, 1
                request = request.send JSON.stringify data
            response = (yield request).res
            debug.response JSON.stringify response.body, null, 2 if response?.body?
            console.info "< #{response.statusCode} (#{response.statusMessage})"
            # queue unfinished tasks
            if response.statusCode is 202
                taskQueue.addTask response.headers.location

            return response
        catch err
            response = err.response.res
            throw new Error "Failed to #{msg}: #{response.statusCode} (#{response.statusMessage})\n#{response.text}"

    service.waitTillOpenTasksHaveFinished = Promise.coroutine ->
        yield taskQueue.waitTillOpenTasksHaveFinished()

    return service
