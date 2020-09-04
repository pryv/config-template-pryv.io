
# Config upgrade from version 1.5 to 1.6.0

This is the initial instruction for upgrade Pryv.io system from 1.5 to 1.6. If you have earlier version, please first update to Pryv.io 1.5.

## What is new

Please check what is  new with Pryv.io 1.6 here ???

## What upgrades has to be made

To upgrade Pryv.io to 1.6 these steps have to be made

1. Upgrade Pryv.io config to add new system streams 
(use tutorial in file `CONFIG-UPGRADE-FROM-1.5-TO-1.6.md`)

2. Upgrade Pryv.io database from 3.6 to 4.2 
(use tutorial in file `DATABASE-UPGRADE-FROM-1.5-TO-1.6.md`)

3. Set a new version of Pryv.io core, mongodb containers from 1.5.x to 1.6.0 in your 
config-leader/data/core/pryv.yml file ???

4. Set a new version of the Pryv.io register container from 1.3.x to 1.6.0 in your 
 config-leader/data/reg-master/pryv.yml file ???
 
5. Launch the platform with ???
 
6. Validate changes by trying to register a new user??? steps about new path, parameters, regsiter-hostings should be here?


<b>Congratulations!</b>