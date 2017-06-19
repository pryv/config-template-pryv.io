in the `pryv.io/` folder, you will find the template configuration files for a pryv.io scale installation.
 
 
# Usage

* Copy this repository content in new repository `config-DOMAIN`
* Replace the installation variables in the configuration files. You may replace most of those values by making a *find/replace* for ${VAR_NAME}.  
* Update general information in `pryv.io/README.md`
* If needed, update container versions in `pryv.io/{core,reg,static}.yml`
* Follow the Usage instructions in `pryv.io/README.md`


# Installation Information

IP Addresses: 

Service-Core        TODO
Service-Register    TODO
Static-Web          TODO
 
Domain name: 

${DOMAIN}
 
Name servers: 

dns1.${DOMAIN}
dns2.${DOMAIN}


# Overview

`pryv.li/` contains docker compose YAML files for creating a pryv.io scale
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

