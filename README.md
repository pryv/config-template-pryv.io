# Pryv.io scalable configuration template

In the `pryv.io/` folder, you will find the template configuration files for a pryv.io scale installation.
 
 
## Usage

*Prerequisites*: Node v6+

* Copy this repository content in new repository `config-DOMAIN`
* Replace the [installation variables](#installation-variables) in the `pryv.io/config.yml` file. If migrating from a v1.1 installation, see **Upgrade from v1.1** below.
* run `npm run fromYaml` to generate v1.2 compatible configuration files in `pryv.io/fromYaml/`.
* Update **Installation information** in `pryv.io/README.md`
* If needed, update container versions in `pryv.io/{core,reg,static}.yml`
* Follow the Usage instructions in `pryv.io/README.md`


### Upgrade from v1.1

* Copy the following files in `v1.1-config/`:
 * `registration-server.config.json`
 * `service-core-api.config.json`
 * `service-core-preview.config.json`
 * `static-web.config.json`
* Run `npm run toYaml` to generate the `pryv.io/config.yml`


## Overview

`pryv.io/` contains docker compose YAML files for creating a pryv.io scale
installation with standard directory structure. 

In general, YAML files will assume that the configuration file root is at 
`/var/pryv/`. You should reference this directory as ${PRYV_CONFIG_ROOT} in the
docker compose files. 

You should find here: 

    core.yml      Compose file for launching a core machine.
    core/         Configuration template for the core machine. 
    reg.yml       Compose file for launching a registry machine. 
    reg/          Configuration template for the registry machine. 
    static.yml    Compose file for launching a static web machine. 
    static/       Configuration template for the static web machine. 
    
Configuration files are written for a test of the environment through the rec.la
domain. You will need to copy and customize the files for the client before
distribution. 


## Installation variables

Replace specifics with generic ones & find a way to comment or explain it.


### v1.1 to v1.2 upgrade notes

#### Modifications

A few modifications are applied during the upgrade, they can be found [here](https://github.com/pryv/config-template-pryv.io-scale/blob/master/src/yaml-to-v1.2.js#L149)

* Port for dns and preview have been changed
* `eventFiles` & `logs/file/path` paths are different and will be for docker & classical deployments.
* logs.console/file have different values on active, level & colorize
* register.server.ip (=127.0.0.1) is deleted as it is now in docker network
* swww.http.ip (=127.0.0.1) is deleted as it is now in docker network


#### Propositions to change

* http.noSSL parameter is present but unused!!! -> to ignore
* in core: `nightlyScriptCronTime` doesn't appear as it was matching the default value assigned in config.js. -> Remove it from config
* env: is missing, but apiServer & preview are in production by default. -> Remove it from config
* auth.browserIdAudience is not found in core -> to delete?


#### To discuss

* in dns.json: 
	* store machines ip adresses?  
	* store cores ip adresses, giving them either a name depending on their position in the cores array or some other pattern.
* in DNS source code (v1.1 & v1.2): domainA is not found
* airbrake uses *active* in coreApi, preview, but *disable* in register
* What is `http2` in static-web
* Do we keep database passwords or disable them during upgrade?


#### Databases passwords

MongoDB on v1.1 had a password as it was not isolated from the public network interface. In the containerized version,
MongoDB runs in a container whose network interface is exclusively reachable from the core & preview containers.  
Therefore we don't use username/password credentials anymore.
