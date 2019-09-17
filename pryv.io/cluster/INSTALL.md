
This manual contains installation instructions for a three-server setup of Pryv.
You should have prepared your server with the Installation Prerequisites manual
first. 

# Prerequisites Check

Please run these commands and compare the output with the contents of this manual. 
You might have to use `docker-ce` and your versions can be newer: 

    $ docker -v
    Docker version 17.05.0-ce, build 89658be
    
    $ docker-compose -v
    docker-compose version 1.18.0, build 8dd22a9

If your DNS is set up correctly, the following command should yield the fully qualified domain name of the machine you intend to use as a central Pryv registry server: 

    $ dig NS ${DOMAIN}

Normally, your NS records should resolve to the names you gave to the registry server you intend to set up. Please check if your A records exist and point to the same machine. 
    
# Configuration Install

The instructions below need to be repeated for each of the machines that
are part of your configuration. You should have received several configuration
files, one for each role: 'static', 'reg-master', 'reg-slave', 'core'. We'll use the placeholder
${ROLE} to refer to these roles below.

Please create a directory where all your Pryv data should live. We suggest something like `'/var/pryv'`. For the purposes of this document, we'll refer to that location as `${PRYV_CONF_ROOT}`. Then follow these steps: 

  * Copy the configuration tarball to the root of the directory. 
  * Untar the configuration in place.  

You should have the three following entries now: 

  * A file called `delete-user.md`. This presents a tool which allows to delete Pryv.io users.
  * A file called `ensure-permissions-${ROLE}`. This script ensures that the correct 
    permissions are set for data and log directories.
  * The file `run-config-leader` and folder `config-leader`. This is the script and configuration files that is used to launch the configuration leader service. The leader is usually hosted on the machine with role 'reg-master'.
  * The file `run-config-follower` and folder `config-follower`. This is the script and configuration files that is used to launch the configuration follower service. There should be one follower service on each machine.
  * A file called `run-pryv`. This is your startup script. 
  * A directory called `pryv`. This contains configuration and data
    directories that will be mapped as volumes in the various docker 
    containers.
  * The files `stop-config-leader`, `stop-config-leader` and `stop-pryv`. These scripts stop the corresponding running containers.

# Completing the Configuration

## Leader-follower setup

The configuration leader service will communicate with the configuration follower services in order to setup the necessary configuration files for your Pryv.io platform.

Followers can be declared through the leader configuration, as follows:
  - Set a symmetric key to authenticate each follower in `${PRYV_CONF_ROOT}/config-leader/conf/config-leader.json` as `followers:${FOLLOWER_KEY}`
  - Also set here each follower's role (core, reg-master, reg-slave, static) and url
  - Set the symmetric key defined above in the corresponding follower configuration in `${PRYV_CONF_ROOT}/config-follower/conf/config-follower.json` after `leader:auth`
  - Set the leader url in each follower configuration in `${PRYV_CONF_ROOT}/config-follower/conf/config-follower.json` after `leader:url` (usually `https://lead.${DOMAIN}`)

Also, you can set an admin key for the configuration follower service in:

  - `${PRYV_CONF_ROOT}/config-leader/conf/config-leader.json` after `adminKey`

## SSL certificates

All services use Nginx to terminate inbound HTTPS connections. You should have obtained a wildcard certificate for your domain to that effect. You will need to store that certificate along with the CA chain into the appropriate locations. Please follow this [link](https://www.digicert.com/ssl-certificate-installation-nginx.htm) to find instructions on how to convert a certificate for nginx. 

Your certificate files for the respective roles must be placed on the leader machine in these locations: 
  - `${PRYV_CONF_ROOT}/config-leader/data/${ROLE}/nginx/conf/secret/${DOMAIN}-bundle.crt`
  - `${PRYV_CONF_ROOT}/config-leader/data/${ROLE}/nginx/conf/secret/${DOMAIN}-key.pem`

If you wish to store the files in a different location, please edit the nginx server configuration files in `${PRYV_CONF_ROOT}/config-leader/data/${ROLE}/nginx/conf/nginx.conf` to point to the files.  

Don't forget to update 'serial' if you edit reg-master/register/conf/register.json

# Launching the Installation

To launch the installation, you will first need to log in to the distribution host for the Pryv docker images. You should have received a set of credentials with the delivery of the configuration files. The following assumes that you have a user id (${USER_ID}) and a secret (${SECRET}).

To log in, type: 

    $ docker login pryvsa-docker-release.bintray.io

You will be prompted for a username and password. Please enter the credentials you were provided.

Once this completes, set the required permissions on data and log directories by running the following script:

    $ sudo ./ensure-permissions-${ROLE}

You're now ready to launch the pryv components. First, run the configuration leader service on leader machine: 

    $ sudo ./run-config-leader

Then, run the configuration follower service on each machine, which will pull the necessary configuration files from the leader.

  $ sudo ./run-config-follower

Now that the configuration is ready, you can launch the platform:

  $ sudo ./run-pryv

This command will download the docker images that belong to your release from the docker repository and launch the components. If all goes well, you'll see a number of running docker containers when you start `docker ps`.

# Closing Remarks

You should now have a working docker installation. You can test this by directing a browser at [https://sw.${DOMAIN}/access/register.html](https://sw.${DOMAIN}/access/register.html) and filling in the form. 

If you need support, please contact your account manager @ Pryv. We're glad to help you with any questions you might have. 
