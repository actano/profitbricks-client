# Setup

Prerequisites:
- [git](https://git-scm.com/downloads) in your PATH
- [node and npm](https://nodejs.org/en/) in your PATH

1. clone this repo: `git clone https://github.com/actano/bootstrap.git`
2. enter the directory: `cd bootstrap`
3. install npm modules: `npm i`
4. run the script, for instance: `npm run coffee profitbricks/restAPI/playground.coffee`


# Usage

	{Builder} = require './builder'
	Synchronizer = require './synchronizer'
	synchronizer = new Synchronizer builder

`Builder` creates an internal datastructure which is similar to the datastructure 
of [profitbricks](https://devops.profitbricks.com/api/rest/#overview)

To see how to create a datacenter with servers and LANs take a look
into the `playgroud.coffee`. You have a builder fluent API and a JSON import API.

To create a datacenter from a builder instance on profitbricks, you have this API:

`synchronizer.uploadAndReplace()` - creates a new datacenter, delete if there is already an existing one with the same name

`synchronizer.verify()` - checks if the datacenter in the builder is equal to the remote datacenter at profitbricks

`synchronizer.addMissingServers()` - creates missing servers, which are contained in the builder but are missing remote at profitbricks


## Issues & Limitations

### Limitations

- servers can only have one volume (boot volume)
- server can't be changed after first initialization
- LANs can't be changed nor created after first initialization

### Dynamic public IP will always be shown as a change

Maybe this does not happen on production (because you're using a static IP), but when you're using a public IP which is dynamic, you can't
specify it in your builder. If you call `verify()` you will receive an diff for the IP.

#### LAN names are changed when using the Webinterface

If you change something in the [webinterface of profitbricks](https://my.profitbricks.com/dashboard)
__even__ if it's just a visual movement of an entity, the LAN names will be changed.
So after you confirm the provisioning, the next `synchronizer.verify()` call will break with an error like this:

```
unhandled rejection Error: LAN with name public not found. Available LANs: Switch for LAN 2,Switch for LAN 1
```
Even worse: you cannot rename the LAN anymore, thanks to @profitbricks :+1:
