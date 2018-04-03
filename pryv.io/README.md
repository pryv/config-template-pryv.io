# Pryv.io configuration files

This directory contains the configuration files for a pryv.io installation. 

## Usage

### Update configuration files

*Prerequisites:* Yarn v0.27+, Node v8+

Modify `config.yml`, then run `yarn fromYaml` to update the files in `core/`, `reg-master/`, `reg-slave/` & `static/`. 

We are currently in a transition phase where we wish to simplify our configuration files. `config.yml` is the ongoing work of what we are tending to and the `src/yaml-to-v1.2.js` script does the translation into the current format. 

### Sync files to remote hosts
To sync files with remote hosts use: `./scripts/sync-to-remote ${ROLE}` where ROLE is either: cores, static, reg-master or reg-slave

### Sync files from remote hosts
Use `rsync -av HOST:PATH_TO_FOLDER PATH_TO_FOLDER`

### Generate necessary files to install service
To compress configuration files in tarballs, run `./scripts/build DOMAIN`. This will generate the following files in `tarballs/`:
- DOMAIN-core.tgz
- DOMAIN-reg.tgz
- DOMAIN-static.tgz

## Guides

* [INSTALL.md](https://github.com/pryv/config-template-pryv.io/blob/master/pryv.io/INSTALL.md) contains the instructions to install the Core, Register and Static-web software on the dedicated machines.
 
* [UPDATE.md](https://github.com/pryv/config-template-pryv.io/blob/master/pryv.io/UPDATE.md) contains the instructions to reboot the containers.
