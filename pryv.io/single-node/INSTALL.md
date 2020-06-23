# Pryv.io installation guide

This guide contains instructions to install a Pryv.io single-node platform.
You should have prepared your machines with the [Deployment Design Guide](https://api.pryv.com/customer-resources/#documents) first. 
​
## Table of contents

 - Centralized configuration setup 
 - pryv directory
 - Platform setup
 - SSL certificates
 - Launching the Installation
   - Prerequisites check
   - Run
   - Validation
   - Stop
 - Closing Remarks

## Centralized configuration setup

We have released a new configuration scheme:

The platform configurations are stored on a single leader service, each role will fetch its configuration files from it upon installation using its follower service.

For a single-node setup, the leader and a single follower both run on the machine.

## pryv directory

In addition to the configuration files, we distribute scripts to launch and stop the services.

You should have received the configuration files, packaged in an archive (.tgz).

The following instructions need to be executed on the single-node machine:

- Please create a directory where all your Pryv data should live. We suggest something like `/var/pryv/`,
- Absolute path to this location has to be stored under environment variable named `PRYV_CONF_ROOT` - you may use the script below to have it done,
- Copy the configuration archive to the root of the directory,
- Unarchive the configuration in place.

```bash
export PRYV_CONF_ROOT="/var/pryv"
mkdir $PRYV_CONF_ROOT
tar xvf template-single-node.tgz -C $PRYV_CONF_ROOT --strip-components=1
cd $PRYV_CONF_ROOT
```

## Platform setup

Define the platform-specific variables in `${PRYV_CONF_ROOT}/config-leader/conf/platform.yml`. The leader service will replace them in the template configuration files located in the `${PRYV_CONF_ROOT}/config-leader/data/` folder when queried.

## SSL certificates

All services use Nginx to terminate inbound HTTPS connections. You should have obtained a wildcard certificate for your domain to that effect. You will need to store that certificate along with the CA chain into the appropriate locations. Please follow this [link](https://www.digicert.com/ssl-certificate-installation-nginx.htm) to find instructions on how to convert a certificate for nginx. 

Your certificate files must be placed in these locations: 

  - `${PRYV_CONF_ROOT}/config-leader/data/singlenode/nginx/conf/secret/${DOMAIN}-bundle.crt` 
  - `${PRYV_CONF_ROOT}/config-leader/data/singlenode/nginx/conf/secret/${DOMAIN}-key.pem`

## Launching the Installation

### Prerequisites Check

Please run these commands and compare the output with values below.
You might have to use `docker-ce` and your versions can be newer:

    $ docker -v
    Docker version 17.05.0-ce, build 89658be
    
    $ docker-compose -v
    docker-compose version 1.18.0, build 8dd22a9

If your DNS is set up correctly, the following command should yield the fully qualified domain name of the machine you intend to use as a central Pryv Register server: 

    $ dig NS ${DOMAIN}

Normally, your NS records should resolve to the names you gave to the Register server you intend to set up. Please check that the A records of the returned NS entries exist and point to the same machine. 

### Run

To launch the installation, you will first need to authenticate with the distribution host to retrieve the Pryv.io docker images. You should have received a set of credentials with the delivery of the configuration files. The following assumes that you have a user id (${USER_ID}) and a secret (${SECRET}).

To log in, type: 

    docker login pryvsa-docker-release.bintray.io

You will be prompted for a username and password. Please enter the credentials you were provided.

Once this completes, set the required permissions on data and log directories by running the following script:

    sudo ./ensure-permissions

Run the configuration leader service: 

    sudo ./run-config-leader

Then, run the configuration follower service, which will pull the necessary configuration files
 from the leader.

    sudo ./run-config-follower

Now that the configuration is ready, you can launch the Pryv.io components:

    sudo ./run-pryv

This command will download the docker images that belong to your release from the docker repository and launch the component. If all goes well, you'll see a number of running docker containers when you start `docker ps`.

#### Reporting

Each Pryv.io module sends a report to Pryv upon start, containing the following contractual information:

- license Key
- users count
- template version
- hostname
- role

If you decide to opt out, please contact your account manager @ Pryv to define another way to communicate this information.

You can disable the reporting by setting uncommenting the following line in the `run-pryv` script:

```
#export reporting_optOut="true"
```

### Stop

Finally, the scripts `stop-config-leader`, `stop-config-follower` and `stop-pryv` shut down the corresponding running services.

### Validation

Please refer to the `Installation validation` document located in the [customer resource documents](https://api.pryv.com/customer-resources/#documents) to validate that your Pryv.io platform is up and running.

## Closing Remarks

If you need support, please contact your technical account manager @ Pryv or open a ticket on [our helpdesk](https://pryv.com/helpdesk/). We're glad to help you with any questions you might have.