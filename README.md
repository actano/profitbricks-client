# Setup

Prerequisites:
- [git](https://git-scm.com/downloads) in your PATH
- [node and npm](https://nodejs.org/en/) in your PATH

1. clone this repo: `git clone https://github.com/actano/profitbricks-client.git`
2. enter the directory: `cd profitbricks-client`
3. install npm modules: `npm i`
4. run the script, for instance: `$(npm bin)/coffee examples/executor.coffee`

# Authentication

Authentication with ProfitBricks is made via username and password. To set these use the environment variables
`PROFITBRICKS_USER` and `PROFITBRICKS_PASSWORD`.

# Usage

    {Builder} = require './builder'
    Synchronizer = require './synchronizer'
    synchronizer = new Synchronizer builder

`Builder` creates an internal datastructure which is similar to the datastructure
of [profitbricks](https://devops.profitbricks.com/api/rest/#overview)

To see how to create a datacenter with servers and LANs take a look
into the `examples/datacenterDefinition.coffee`.

## Issues & Limitations

### Limitations

- servers can only have one volume (boot volume)
- server can't be changed after first initialization
- LANs can't be changed nor created after first initialization

### Dynamic public IP will always be shown as a change

Maybe this does not happen on production (because you're using a static IP), but when you're using a public IP which is dynamic, you can't
specify it in your builder. If you call `verify()` you will receive an diff for the IP.
