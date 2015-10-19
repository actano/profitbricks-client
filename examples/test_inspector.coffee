Promise = require 'bluebird'
DcInspector = require './../src/datacenterInspector'
{Datacenter} = require './../src/models'
{defaults} = require './datacenterDefinition'
{complexDatacenter} = require './datacenterDefinition'
{simpleDatacenter} = require './datacenterDefinition'

testDiffLansOnly = Promise.coroutine  ->
    dcDefinition =
        name: 'Test_Christian_500'
        description: 'Remove me quickly'
        location: 'de/fra'

        lans: [
            name: 'public'
            public: true
        ,
            name: 'managed'
        ]

    existingDc =
        properties:
            name: 'Test_Christian_500'
            description: 'Remove me quickly'
            location: 'de/fra'
        entities:
            lans:
                items: [
                    properties:
                        name: 'public'
                        public: true
                ]


    dc = new Datacenter dcDefinition, defaults
    inspector = new DcInspector dc

testDiffArrays = ->
    dcDefinition =
        name: 'Test_Christian_500'
        description: 'Remove me quickly'
        location: 'de/fra'

        lans: [
            name: 'public'
            public: true
        ,
            name: 'managed'
        ]

    remote = [
        properties:
            name: 'balanced'
            public: false
    ,
        properties:
            name: 'public'
            public: false
    ]

    dc = new Datacenter dcDefinition, defaults

    inspector = new DcInspector()
    inspector._diffArrays dc.getLans(), remote, 'Lan', 'Datacenter (\'Test\') ->'

testFindDuplicates = ->
    inspector = new DcInspector()
    console.log inspector._findDuplicates [3,2,1,3,2,3]

testFullDc = Promise.coroutine ->
    inspector = new DcInspector()
    dc = new Datacenter simpleDatacenter, defaults
    yield inspector.inspect dc

#testDiffArrays()
#testFindDuplicates()
testFullDc()




