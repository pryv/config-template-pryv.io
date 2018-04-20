# Configuration Install

The instructions below need to be repeated for each of the three machines that
are part of your configuration. You should have received three configuration
files, one for each role: 'static', 'reg', 'core'. We'll use the placeholder ${ROLE}
to refer to these roles below. 

If not done already, please create a directory where all your Pryv data should live. We suggest something like `'/var/pryv'`. For the purposes of this document, we'll refer to that location as ${PRYV_CONF_ROOT}. Then follow these steps: 

  * Copy the configuration tarball to the root of the directory. 
  * Untar the configuration in place. 

You should have three directory entries now: 

  * A file called `run-${ROLE}`. This is the previous startup script. 
  * A file called `restart-${ROLE}`. This is your reboot script, to load changes in configuration
  * A file called `${ROLE}.yml` - this is the docker-compose script that is 
    used to launch the service. 
  * A directory called ${ROLE} - this contains configuration and data
    directories that will be mapped as volumes in the various docker 
    containers. 

# Completing the Configuration

All three roles use nginx to terminate inbound HTTPS connections. You should
have obtained a wildcard certificate for your domain to that effect. You will
need to store that certificate along with the CA chain into the appropriate
locations. Please follow this
[link](https://www.digicert.com/ssl-certificate-installation-nginx.htm) to find
instructions on how to convert a certificate for nginx. 

Your certificate files must be placed in these locations for the respective
roles: 

  * core: `core/nginx/conf/secret/MYPRYVDOMAIN-bundle.crt`, 
    `core/nginx/conf/secret/MYPRYVDOMAIN-key.pem`
  * static: `static/nginx/conf/secret/MYPRYVDOMAIN-bundle.crt`,
    `static/nginx/conf/secret/MYPRYVDOMAIN-key.pem`
  * reg: `reg/nginx/conf/secret/MYPRYVDOMAIN-bundle.crt`, 
    `reg/nginx/conf/secret/MYPRYVDOMAIN-key.pem`

Please edit the nginx server configuration files in
`${ROLE}/nginx/conf/nginx.conf` to point to the files. Usually, your
configuration will contain a prepared section for this; you'll have to disable
configuration that points to the 'rec.la', this is used to test the
configuration.

# Restarting the services

To launch the installation, you should type

    $ sudo ./restart-${ROLE}
    
This command will reboot the docker containers. If all goes well, you'll see a number of running docker containers when you start `docker ps`.
