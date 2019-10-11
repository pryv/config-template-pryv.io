# Pryv.io installation guide

This guide contains instructions to install a Pryv.io singlenode platform.
You should have prepared your machines with the [Deployment Design Guide](https://api.pryv.com/customer-resources/#documents) first. 
​
## Table of contents

 - Centralized configuration setup 
 - List of Files 
   - Platform variables
 - Emails
 - SSL certificates
 - Launching the Installation
 - Closing Remarks

## Centralized configuration setup

We have released a new configuration scheme:

The platform configurations are stored on a single leader service, each role will fetch its configuration files from it upon installation using its follower service.

For a singlenode setup, the leader and one single follower both run on the singlenode machine.

## List of files

In addition to the configuration files, we distribute scripts to launch and stop the services.

You should have received the configuration files, packaged in an archive (.tgz).

The following instructions need to be executed on the singlenode machine.

- Please create a directory where all your Pryv data should live. We suggest something like `/var/pryv`. For the purpose of this document, we'll refer to that location as `${PRYV_CONF_ROOT}`.
- Copy the configuration archive to the root of the directory
- Unarchive the configuration in place

You should have the following files: 

- The file `run-config-leader` and folder `config-leader/`. These are the script and configuration files used to launch the leader service.
- The file `run-config-follower` and folder `config-follower/`. These are the script and configuration files used to launch the configuration follower service.  
- A file called `run-pryv`. This script will bring the platform up. 
- A directory called `pryv/`. The follower will download the configuration files here, as well as the data directories that will be mapped as volumes in the various docker containers.
- A file called `ensure-permissions`. This script sets correct permissions for data and log directories.

Finally, the files `stop-config-leader`, `stop-config-follower` and `stop-pryv`. These scripts shut down the corresponding running services.

### Platform variables

Define the platform-specific variables in `${PRYV_CONF_ROOT}/config-leader/conf/config-leader.json`. The leader service will replace them in the template configuration files located in the `${PRYV_CONF_ROOT}/config-leader/data/` folder when run.

Here is a list of the required platform-specific variables:

- DOMAIN: the fully qualified domain name of the platform (eg.: pryv.me)
- MACHINE_IP_ADDRESS: IP address of the singlenode machine
- REGISTER_ADMIN_KEY_1: key to make admin calls on register

#### Optional variables

- SERVICE_WEBSITE_IP_ADDRESS: if used, please provide the IP address of the customer or service website - which should resolve http(s)://${DOMAIN}

The following fields will be available in the [service information](https://api.pryv.com/reference/#service-info) for apps self-configuration:

- PLATFORM_NAME: Service name, example "Pryv Lab"
- SUPPORT_LINK: Link to the web page containing support information
- TERMS_OF_USE_LINK: Link to the web page containing terms and conditions

## Pryv.io emails

As explained in the [Emails configuration document](https://api.pryv.com/customer-resources/#documents), the following fields need to be set only when activating Pryv.io emails:

- MAIL_FROM_NAME: name of the sender
- MAIL_FROM_ADDRESS: email address of the sender
- MAIL_SMTP_HOST: host of the SMTP server that will be delivering the emails
- MAIL_SMTP_PORT: SMTP port (default is 587)
- MAIL_SMTP_USER: username to authenticate against the SMTP server
- MAIL_SMTP_PASS: password to authenticate against the SMTP server

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

Normally, your NS records should resolve to the names you gave to the Register server you intend to set up. Please check that your A records exist and point to the same machine. 

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

### Validation

Please refer to the `Installation validation` document located in the [customer resource documents](https://api.pryv.com/customer-resources/#documents) to validate that your Pryv.io platform is up and running.

## Closing Remarks

If you need support, please contact your technical account manager @ Pryv or open a ticket on [our helpdesk](https://pryv.com/helpdesk/). We're glad to help you with any questions you might have. 