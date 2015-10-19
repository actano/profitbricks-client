Promise = require 'bluebird'
DcCreator = require '../src/datacenterCreator'
dcDefinition = require './datacenterDefinition'
{Datacenter} = require '../src/models'
DatacenterToolbox = require '../src/tools'

replaceDC = Promise.coroutine (dc) ->
    datacenter = new Datacenter dc, dcDefinition.defaults
    dcCreator = new DcCreator()
    yield dcCreator.createOrReplaceDatacenter datacenter

updateDC = Promise.coroutine (dc) ->
    datacenter = new Datacenter dc, dcDefinition.defaults
    dcCreator = new DcCreator()
    yield dcCreator.addServersToDatacenter datacenter

replaceComplexDc = Promise.coroutine ->
    datacenter = new Datacenter dcDefinition.complexDatacenter, dcDefinition.defaults
    dcCreator = new DcCreator()
    yield dcCreator.createOrReplaceDatacenter datacenter

stopAllServers = Promise.coroutine (name) ->
    tb = new DatacenterToolbox(name)
    yield tb.stopAllServers()

replaceDC dcDefinition.simpleDatacenter
#updateDC dcDefinition.simpleDatacenterPlus
#replaceDC dcDefinition.complexDatacenter
#stopAllServers dcDefinition.simpleDatacenter.name

