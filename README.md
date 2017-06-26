# Pryv.io scalable configuration template

In the `pryv.io/` folder, you will find the template configuration files for a pryv.io scale installation.
 
 
## Usage

* Copy this repository content in new repository `config-DOMAIN`
* Replace the [installation variables](#installation-variables) in the configuration files. You may replace most of those values by making a *find/replace* for ${VAR_NAME}.  
* Update **Installation information** in `pryv.io/README.md`
* If needed, update container versions in `pryv.io/{core,reg,static}.yml`
* Follow the Usage instructions in `pryv.io/README.md`


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

Global
- DOMAIN: (eg.: pryv.me)
- REGISTER_SYSTEM_KEY: key used by cores to make calls on register's /system path
- REGISTER_ADMIN_KEY_N: key(s) used by admins to make calls on register's /admin methods
- CORE_SYSTEM_KEY: key used by register to make calls on cores' /system path
- SSO_COOKIE_SECRET: used by cores to secure cookie
- FILES_READ_TOKEN_SECRET: used by cores to secure file tokens
- STATIC_WEB_IP: IP address of static-web
- REG_IP: IP address of register
- CORE_N_IP: IP address of core N
- MONGO_USER *(optional)*: username for MongoDB connection
- MONGO_PASSWORD *(optional)*: password for MongoDB connection

Global extra services
- MANDRILL_API_KEY *(optional)*: API key for Mandrill mailing service 
- AIRBRAKE_CORE_API_KEY *(optional)*: API key for Airbrake error monitoring service
- AIRBRAKE_REG_API_KEY *(optional)*: API key for Airbrake error monitoring service
- AIRBRAKE_PREVIEW_API_KEY *(optional)*: API key for Airbrake error monitoring service
- AIRBRAKE_APP-WEB_API_KEY *(optional)*: API key for Airbrake error monitoring service

Per Core
- CORE_N_NAME: legible identifier for core machine 
- CORE_N_URL: fully qualified URL by which the core is reachable, defined either in the `pryv.net` DNS zone file or in the `dns.json` config file
- CORE_N_HOSTING_PROVIDER_URL: URL of hosting provider at which the core is hosted, displayed on the registration page when the location is selected   
- CORE_N_DISPLAYED_NAME: Currently not used
- CORE_N_HOSTING_PROVIDER_DESCRIPTION: Hosting provider slogan, displayed on the registration page when the location is selected

Per region
- REGION_N: legible identifier for region, eg.: `europe`
- REGION_N_DISPLAYED_NAME: region name displayed in drop-down choice for hosting location, eg.: `Europe` 

Per zone
- ZONE_N: legible identifier for zone, eg.: `switzerland`. A region can have multiple zones.
- ZONE_N_DISPLAYED_NAME: zone name displayed in drop-down choice for hosting location, eg.: `Switzerland`. Multiple cores in the same zone will appear multiple times with the same name.

Per language:
- LANGUAGE_N
- REGION_N_NAME_DISPLAYED_LANGUAGE_N
- ZONE_N_DISPLAYED_NAME_LANGUAGE_N
- CORE_N_DISPLAYED_DESCRIPTION_LANGUAGE_N


## v1.1 to v1.2 upgrade notes

Configuration files for Static-web and Core can be adapted directly to the new format.
The configuration of Register has been split into reg and dns.


### Databases passwords

Cores v1.1 had passwords as they were not isolated from the public network interface. In the containerized version,
MongoDB runs in a container whose network interface is exclusively reachable from the core & preview containers.  
Therefore we don't use username/password credentials anymore


### DNS/Register config format changes

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
