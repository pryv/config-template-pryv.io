
# Config upgrade from version 1.5.x to 1.6.0

This is the initial instructions for upgrading Pryv.io system from version 1.5 to 1.6.0. If you have earlier version, please first update to Pryv.io 1.5.

## What is new

Please check what is  new with Pryv.io 1.6 [here](https://pryv.github.io/change-log/)

## What upgrades need to be made

To upgrade Pryv.io to the version 1.6, the following steps need to be done:

1. Before you start, make sure you have 1 user per core login credentials that you will use in the end of this tutorial
to test the upgrade.

2. Upgrade Pryv.io config to add new system streams 
(use tutorial in file `CONFIG-UPGRADE-FROM-1.5-TO-1.6.md`)

3. Set a new version of the Pryv.io `register`, `dns` containers from 1.3.x to 1.6.0 in your 
 config-leader/data/reg-master/pryv.yml file.
 
4. Upgrade Pryv.io database from 3.6 to 4.2 
(use tutorial in file `DATABASE-UPGRADE-FROM-1.5-TO-1.6.md`)

5. Set a new version of the Pryv.io `core`, `mongodb`, `preview`, `hfs` containers from 1.5.x to 1.6.0 in your 
config-leader/data/core/pryv.yml file.

 
6. Reboot services in each core server from your Pryv.io project root folder with 

    ```
    ./ensure-permissions-${ROLE}
    ./restart-config-follower
    ./restart-pryv
    ```
7. In each core server check when migration process is finished, it may take some time
because all indexes have to be recreated. You can monitor the process with:

    ```
   For the mongodb:
    tail -n 100 -f $PRYV_CONF_ROOT/pryv/mongodb/log/mongodb.log
  
   If there are many users, the process could timout. 
   If that is the case, please restart the services in $PRYV_CONF_ROOT with ./restart-pryv.   
   
   For the core service:
   docker logs -f pryvio_core
   ```


8. Validate changes by trying to:
    1. Login with the old user
    2. Register a new user
    
9. If everything is successful, you can remove database migration related containers and images.
    ```
    docker rm pryvio_mongodb_migration_step_1
    docker rm pryvio_mongodb_migration_step_2
    docker rmi pryvsa-docker-release.bintray.io/pryv/mongodb:migration-4.0.20
    docker rmi pryvsa-docker-release.bintray.io/pryv/mongodb:migration-4.2.9
    ```
   
 Also, you can delete old, not used images (you can see the list of all docker images by running `docker images`)

More information about new registration path, parameters and features could be found [here](https://pryv.github.io/customer-resources/system-streams/) 
and [here](https://pryv.github.io/reference/#account-creation)

**Congratulations!**