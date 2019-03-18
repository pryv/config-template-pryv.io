
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

    $ dig NS DOMAIN

Normally, your NS records should resolve to the names you gave to the registry server you intend to set up. Please check if your A records exist and point to the same machine. 
    
# Configuration Install

The instructions below need to be repeated for each of the three machines that
are part of your configuration. You should have received three configuration
files, one for each role: 'static', 'reg', 'core'. We'll use the placeholder
${ROLE} to refer to these roles below. 

Please create a directory where all your Pryv data should live. We suggest something like `'/var/pryv'`. For the purposes of this document, we'll refer to that location as `${PRYV_CONF_ROOT}`. Then follow these steps: 

  * Copy the configuration tarball to the root of the directory. 
  * Untar the configuration in place.  

You should have the three following entries now: 

  * A file called `run-${ROLE}`. This is your startup script. 
  * A file called `${ROLE}.yml` - this is the docker-compose script that is 
    used to launch the service. 
  * A directory called ${ROLE} - this contains configuration and data
    directories that will be mapped as volumes in the various docker 
    containers. 
  * A file called `stop-containers`. This script stops all running containers.

# Completing the Configuration

All services use Nginx to terminate inbound HTTPS connections. You should have obtained a wildcard certificate for your domain to that effect. You will need to store that certificate along with the CA chain into the appropriate locations. Please follow this [link](https://www.digicert.com/ssl-certificate-installation-nginx.htm) to find instructions on how to convert a certificate for nginx. 

Your certificate files must be placed in these locations for the respective roles:  

  * core: `core/nginx/conf/secret/MYPRYVDOMAIN-bundle.crt`, 
    `core/nginx/conf/secret/MYPRYVDOMAIN-key.pem`
  * static: `static/nginx/conf/secret/MYPRYVDOMAIN-bundle.crt`,
    `static/nginx/conf/secret/MYPRYVDOMAIN-key.pem`
  * reg: `reg/nginx/conf/secret/MYPRYVDOMAIN-bundle.crt`, 
    `reg/nginx/conf/secret/MYPRYVDOMAIN-key.pem`

If you wish to store the files in a different location, please edit the nginx server configuration files in `${ROLE}/nginx/conf/nginx.conf` to point to the files.   

# Launching the Installation

To launch the installation, you will first need to log in to the distribution host for the Pryv docker images. You should have received a set of credentials with the delivery of the configuration files. The following assumes that you have a user id (${USER_ID}) and a secret (${SECRET}).

To log in, type: 

    $ docker login pryvsa-docker-release.bintray.io

You will be prompted for a username and password. Please enter the credentials you were provided.

Once this completes, you're ready to launch the pryv component. To launch the installation, you should type:  

    $ sudo ./run-${ROLE}
    
This command will download the docker images that belong to your release from the docker repository and launch the component. If all goes well, you'll see a number of running docker containers when you start `docker ps`.

# Closing Remarks

You should now have a working docker installation. You can test this by directing a browser at [https://sw.DOMAIN/access/register.html](https://sw.DOMAIN/access/register.html) and filling in the form. 

If you need support, please contact your account manager @ Pryv. We're glad to help you with any questions you might have. 
