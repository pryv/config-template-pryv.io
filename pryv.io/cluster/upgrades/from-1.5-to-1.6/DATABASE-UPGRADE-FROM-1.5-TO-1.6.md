
# Database upgrade from 1.5 to 1.6

This guide describes how to upgrade your MongoDB from 3.6 to 4.2 version. It is only valid if you have Pryv.io installed with the version 1.5. 
If you have earlier version, please upgrade it to 1.5 version first.

## Backup current configuration

Connect to each of your cores and backup your latest MongoDB configuration file. It should be located in your `${PRYV_CONF_ROOT}/pryv/mongodb/conf/` folder.

## Backup current database

Backup your latest mongo database.

## Steps

1. Set your Pryv.io root folder 
    ```
    PRYV_CONF_ROOT=<your PRYV_CONF_ROOT path>
    ```
2. Stop any running containers: run 
    ```
    docker stop $(docker ps -a -q)
   Ask Ilia - maybe better - ./stop-pryv
    ```
3. Start first MongoDB upgrade step while being in the folder of this tutorial: 
    ```
     PRYV_CONF_ROOT=$PRYV_CONF_ROOT docker-compose -f mongo-upgrade-from-3.6-to-4.2.yml up --detach pryvio_mongodb_migration_step_1
    ```
4. Update MongoDB compatibility: 
    
    ```
    docker exec -it pryvio_mongodb_migration_step_1 /bin/sh /app/setFeatureCompatibilityVersion.sh
    ```
   The answer should contain '"ok" : 1', if it doesn't, you can check the logs with the commands below.
   ```
    (if you switch windows don't forget to set PRYV_CONF_ROOT that you did in the first step):
    
    tail -f $PRYV_CONF_ROOT/pryv/mongodb/log/mongodb.log
    ```
5. If everything is successful, stop the migration container:
    ```
    docker stop pryvio_mongodb_migration_step_1
    ```
6. Start second MongoDB upgrade step: 
    ```
    PRYV_CONF_ROOT=$PRYV_CONF_ROOT docker-compose -f mongo-upgrade-from-3.6-to-4.2.yml up --detach pryvio_mongodb_migration_step_2
   ```
7. Update mongo settings: 
    ```
    docker exec -it pryvio_mongodb_migration_step_2 /bin/sh /app/convertToReplicaSet.sh
    ```
8. Stop second migration container: 
    ```
    docker stop pryvio_mongodb_migration_step_2
    ```
9. Continue with the platform update steps from the file `MAIN-UPGRADE-FROM-1.5-TO-1.6.md`.