
# Config upgrade from version 1.5 to 1.6.0

This is the initial instructions for upgrading Pryv.io system from version 1.5 to 1.6.0. If you have earlier version, please first update to Pryv.io 1.5.

## What is new

Please check what is  new with Pryv.io 1.6 here ???

## What upgrades need to be made

To upgrade Pryv.io to the version 1.6, the following steps need to be done:

1. Before you start, make sure you have 1 user login credentials that you will use in the end of this tutorial
to test the upgrade.

2. Upgrade Pryv.io config to add new system streams 
(use tutorial in file `CONFIG-UPGRADE-FROM-1.5-TO-1.6.md`)

3. Upgrade Pryv.io database from 3.6 to 4.2 
(use tutorial in file `DATABASE-UPGRADE-FROM-1.5-TO-1.6.md`)

4. Set a new version of the Pryv.io core, MongoDB containers from 1.5.x to 1.6.0 in your 
config-leader/data/core/pryv.yml file ???

5. Set a new version of the Pryv.io register container from 1.3.x to 1.6.0 in your 
 config-leader/data/reg-master/pryv.yml file ???
 
6. Launch the Pryv.io from your Pryv.io project root folder with ./run_pryv from each core.
 
7. Validate changes by trying to:
    1. Login with the old user
    2. Register a new user
     
??? More information about new registration path, parameters and features could be found here???


**Congratulations!**