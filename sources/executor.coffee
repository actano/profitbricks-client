Promise = require 'bluebird'
DcCreator = require './datacenterCreator'
dcDefinition = require './datacenterDefinition'
{Datacenter} = require './models'

replaceSimpleDC = Promise.coroutine ->
    datacenter = new Datacenter dcDefinition.simpleDatacenter, dcDefinition.defaults
    dcCreator = new DcCreator()
    yield dcCreator.createOrReplaceDatacenter datacenter

updateSimpleDC = Promise.coroutine ->
    datacenter = new Datacenter dcDefinition.simpleDatacenterPlus, dcDefinition.defaults
    dcCreator = new DcCreator()
    yield dcCreator.addServersToDatacenter datacenter

replaceComplexDc = Promise.coroutine ->
    datacenter = new Datacenter dcDefinition.complexDatacenter, dcDefinition.defaults
    dcCreator = new DcCreator()
    yield dcCreator.createOrReplaceDatacenter datacenter

#replaceSimpleDC()
#updateSimpleDC()
replaceComplexDc()
