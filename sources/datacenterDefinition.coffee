defaults =
    lan:
        public: false
    server:
        ram: 1024
        cores: 1
        availabilityZone: 'AUTO'
    volume:
        type: 'HDD'
        size: 30
        image: 'ubuntu-trusty-docker-3'
        bus: 'IDE'
        namePostfix: ' - HDD'
    nic:
        dhcp: true
        firewallActive: false
        ips: []

simpleDatacenter =
    name: 'Test_Christian_500'
    description: 'Remove me quickly'
    location: 'de/fra'

    lans: [
        name: 'public'
        public: true
    ,
        name: 'managed'
    ]
    servers: [
        name: 'ssh-box'
        nics: [
            name: 'public'
        ,
            name: 'managed'
            ips: ['10.0.0.1']
        ]
        volumes: [
            name: undefined
        ]
    ]


simpleDatacenterPlus =
    name: 'Test_Christian_500'
    description: 'Remove me quickly'
    location: 'de/fra'

    lans: [
        name: 'public'
        public: true
    ,
        name: 'managed'
    ]
    servers: [
        name: 'ssh-box'
        nics: [
            name: 'public'
        ,
            name: 'managed'
            ips: ['10.0.0.1']
        ]
        volumes: [
            name: undefined
        ]
    ,
        name: 'loadbalancer'
        nics: [
            name: 'public'
        ,
            name: 'managed'
            ips: ['10.0.0.2']
        ]
        volumes: [
            name: undefined
        ]
    ]


complexDatacenter =
    name: 'Test_Christian_500',
    description: 'RPLAN Next Production Datacenter',
    location: 'de/fra'

    lans: [
        name: 'Public'
        public: true
    ,
        name: 'Managed'
    ,
        name: 'Balanced'
    ]
    servers: [
        name: 'loadbox-01 (Loadbalancer)'
        nics: [
            name: 'Public'
        ,
            name: 'Balanced'
            ips: ['10.0.1.1']
        ]
        volumes: [
            name: undefined
        ]
    ,
        name: 'nodebox-01 (App-Server)'
        nics: [
            name: 'Managed'
            ips: ['10.0.1.11']
        ,
            name: 'Balanced'
            ips: ['10.0.1.11']
        ]
        volumes: [
            name: undefined
        ]
    ,
        name: 'nodebox-02 (App-Server)'
        nics: [
            name: 'Managed'
            ips: ['10.0.0.12']
        ,
            name: 'Balanced'
            ips: ['10.0.1.12']
        ]
        volumes: [
            name: undefined
        ]
    ,
        name: 'jumpbox-01 (Jumpbox)'
        nics: [
            name: 'Public'
        ,
            name: 'Managed'
            ips: ['10.0.0.21']
        ]
        volumes: [
            name: undefined
        ]
    ,
        name: 'web-01 (Web-Server)'
        nics: [
            name: 'Managed'
            ips: ['10.0.0.31']
        ,
            name: 'Balanced'
            ips: ['10.0.1.31']
        ]
        volumes: [
            name: undefined
        ]
    ,
        name: 'couchbox-01 (Couchbase)'
        nics: [
            name: 'Managed'
            ips: ['10.0.0.41']
        ]
        volumes: [
            name: undefined
        ]
    ]

module.exports = {
    defaults
    simpleDatacenter
    simpleDatacenterPlus
    complexDatacenter
}
