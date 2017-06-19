# Pryv.io scalable configuration files

This directory contains the configuration files for the ${DOMAIN} pryv.io scalable installation. 


## Installation information

| Service | hostname | IP address 
| --- | -------- | ---------  |
| Core | *optional* | **TODO**
| Register | *optional* | **TODO**
| Static-web | *optional* | **TODO**

 
### Domain name: 

${DOMAIN}
 
### Name servers: 

dns1.${DOMAIN} or ${DNS_1_HOSTNAME}
dns2.${DOMAIN} or ${DNS_2_HOSTNAME}


## Usage

After you have adapted the installation, use the following to install the services on the prepared machines.  

* Run `./script/build ${DOMAIN}` to generate archives `DOMAIN-ROLE.tgz` that you will copy to the corresponding machines (ROLE here is `reg`, `core` or `static`)
* Extract the configuration files using `tar -xzf DOMAIN-ROLE.tgz --strip-components=1`
* Follow the `INSTALL.md` guide 


### Update

To apply changes in the configuration files, follow the instructions in the `UPDATE.md` guide.


## Overview

This directory contains docker compose YAML files for creating a scale
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

