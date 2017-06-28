# Pryv.io scalable configuration template

In the `pryv.io/` folder, you will find the template configuration files for a pryv.io scale installation.
 
 
## Usage

*Prerequisites*: Node v6+

* Copy this repository content in new repository `config-DOMAIN`
* Replace the [installation variables](#installation-variables) in the `pryv.io/config.yml` file. If migrating from a v1.1 installation, see [here](#upgrade-from-v1.1).
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

Configuration files for Static-web and Core can be adapted directly to the new format.
The configuration of Register has been split into reg and dns.


#### Databases passwords

Cores v1.1 had passwords as they were not isolated from the public network interface. In the containerized version,
MongoDB runs in a container whose network interface is exclusively reachable from the core & preview containers.  
Therefore we don't use username/password credentials anymore


#### DNS/Register config format changes

The dns:staticDataInDomain config has had many changes:
- sw, reg are not configured by alias anymore, but by IP address only
- coreN is included now
- service and access pointed to sw's alias, but are missing now
- "import" pointed to "gpaas3.dc0.gandi.net" is now missing
- bridges entries "bridges" & "ifttt" are missing now
- "l", "local" & "reglocal" pointing to "127.0.0.1" are now missing

dns:nameserver is missing
dns:mail as well
service is gone
