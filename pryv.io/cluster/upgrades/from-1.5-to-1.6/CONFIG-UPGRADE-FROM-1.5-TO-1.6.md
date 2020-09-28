
# Config upgrade from version 1.5.x to 1.6.0

This guide describes the config parameters that you should put in place when upgrading your Pryv.io platform from >= 1.0.12 to 1.6, or core version 1.5 to 1.6. If you have an older version, please first upgrade to 1.0.12 or core version 1.5.

## Platform variables

You must edit the `config-leader/conf/platform.yml` according to the system streams definition: https://api.pryv.com/customer-resources/system-streams/

## Main config upgrade sequence 

The guide describes how to update the Pryv.io config is the same as in UPDATE.md
For the consistency, the content of UPDATE.md is listed below: 

1. Backup all your files in all servers.
2. Backup platform parameters and keys:

  - Leader:
    - `${PRYV_CONF_ROOT}/config-leader/conf/platform.yml`
    - `${PRYV_CONF_ROOT}/config-leader/conf/config-leader.json`
  - Followers:
    - `${PRYV_CONF_ROOT}/config-follower/conf/config-follower.json`

3. Untar new template in PRYV_CONF_ROOT: `tar xzfv ${ROLE}.tgz -C ${PRYV_CONF_ROOT} --strip-components=1 --overwrite`
4. Add new values in your `platform.yml`, `config-leader.json` & `config-follower.json` files. Use `diff` to find new values.
5. Replace the template platform config files with your backed up ones
6. Reboot services, starting with reg-master

    6.1 leader: `./restart-config-leader`
    
    6.2 follower: `./restart-config-follower`
    
    6.3 If you are using `app-web-auth3` and have a large users base, you can use
  `pryvsa-docker-release.bintray.io/pryv/register:1.6.0-while-migrating` docker image instead of `pryvsa-docker-release.bintray.io/pryv/register:1.6.0`
  while migrating. It will force the `app-web-auth3` to use the old registration API endpoint until
  you will deploy the new Pryv.io versions to the all cores.
    
    6.4 Pryv.io: `./restart-pryv`
