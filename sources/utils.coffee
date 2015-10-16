utils =
    itemWithThisNameAlreadyExistsGuard: (itemType, items, name) ->
        res = @getItemsByName items, name

        if res.length > 0
            throw new Error "#{itemType} with name '#{name}' already exists!"

    getItemByName: (itemType, items, name) ->
        res = @getItemsByName items, name
        if res.length < 1
            itemsNames = items.map((item) -> item.properties.name).toString()
            throw new Error("#{itemType} with name #{name} not found. Available #{itemType}s: #{itemsNames}")
        if res.length > 1
            throw new Error "More than one #{itemType} with name #{name} found"
        return res[0]

    getItemByNameSimple: (items, name) ->
        res = @getItemsByName items, name
        if res.length < 1
            return null
        if res.length > 1
            throw new Error "More than one #{itemType} with name #{name} found"
        return res[0]

    getItemsByName: (items, name) ->
        return items.filter ((item) -> item.properties.name is name)

    getItemTypeAsString: (item) ->
        return item.type[0].toUpperCase() + item.type.substring 1

    printCollection: (items) ->
        for item in items
            @printItem item

    printItem: (item) ->
        try
            type = item.type[0].toUpperCase() + item.type.substring 1
            console.log "#{type} '#{item.properties.name}': #{item.id}"
        catch err
            console.error 'Item', item
            throw err

    printIps: (server) ->
        for item, index in server.entities.nics.items
            console.log "#{item.name}: #{item.properties.ips.join(' | ')}"

    printTimeInMinutes: (startTime) ->
        time = new Date().getTime() - startTime
        minutes = time / 60000
        console.log 'Time passed in minutes: ', minutes

module.exports = utils

