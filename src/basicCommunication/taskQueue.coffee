Promise = require 'bluebird'

module.exports = (getStatusMethod, sleepTimeInSeconds) ->
    service = {}
    openTasks = []
    failedTasks = []

    service.waitTillOpenTasksHaveFinished = Promise.coroutine ->
        console.info 'Waiting for tasks to finish...'

        while openTasks.length > 0
            yield @updateTaskStatus()
            yield wait()

        if failedTasks.length > 0
            error = createError()
            clear()
            throw error

        clear();

    service.updateTaskStatus = Promise.coroutine ->
        _openTasks = []
        for task in openTasks
            result = yield getStatusMethod task

            switch result.status
                when 'QUEUED', 'RUNNING'
                    _openTasks.push task
                when 'DONE'
                else
                    failedTasks.push {task: task, result: result}

        openTasks = _openTasks

    service.addTask = (task) ->
        openTasks.push task

    wait = Promise.coroutine ->
        yield Promise.delay sleepTimeInSeconds * 1000

    createError = ->
        results = failedTasks
            .map (item) -> "\n#{item.task}: #{JSON.stringify item.result}"
            .concat()

        return new Error "The following tasks have failed: #{results}"

    clear = ->
        openTasks = []
        failedTasks = []

    return service
