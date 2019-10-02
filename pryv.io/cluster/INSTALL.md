# Pryv.io installation guide

This guide contains instructions to install a Pryv.io cluster platform.
You should have prepared your machines with the [Deployment Design Guide](https://api.pryv.com/customer-resources/#documents) first. 

## Table of contents

- Centralized configuration setup

- List of Files

- Platform variables

- Leader-follower keys

- Register slave

- Emails

- SSL certificates

- Launching the Installation

- Automatic restart upon configuration update

- Closing Remarks

  

## Centralized configuration setup

We have released a new configuration scheme: 

The platform configurations are stored on a single **leader** service, each role will fetch its configuration files from it upon installation using its **follower** service.

You must setup your platform configuration in the leader service as well as a key for each follower so they can fetch their configuration securely.

By default, the leader runs on the `reg-master` machine, there is a follower service running on every machine, including `reg-master`.

## List of files

In addition to the configuration files, we distribute scripts to launch and stop the services.

You should have received several configuration files, packaged in archives (.tgz), one for each role: `static`, `reg-master`, `reg-slave`, `core`. We'll use the placeholder `${ROLE}` to refer to them below.

The following instructions need to be executed on each machine.

- Please create a directory where all your Pryv data should live. We suggest something like `/var/pryv`. For the purpose of this document, we'll refer to that location as `${PRYV_CONF_ROOT}`.

- Copy the configuration archive to the root of the directory  
- Unarchive the configuration in place   

In every role, you should have the following files: 

- The file `run-config-follower` and folder `config-follower/`. These are the script and configuration files used to launch the configuration follower service.  
- A file called `run-pryv`. This script will launch the role running on the machine. 
- A directory called `pryv/`. The follower will download the role's configuration files here, as well as the data directories that will be mapped as volumes in the various docker containers.

- A file called `ensure-permissions-${ROLE}`. This script sets correct permissions for data and log directories.

In `reg-master` , you should have these additional files: 

- The file `run-config-leader` and folder `config-leader/`. These are the script and configuration files used to launch the leader service. The leader is usually hosted on the `reg-master` machine.

Finally, the files `stop-config-leader`, `stop-config-follower` and `stop-pryv`. These scripts shut down the corresponding running services.

### Platform variables

Define the platform-specific variables in `${PRYV_CONF_ROOT}/config-leader/conf/config-leader.json`. The leader service will replace them in the template configuration files located in the `${PRYV_CONF_ROOT}/config-leader/data/` folder when run.

Here is a list of the required platform-specific variables:

- DOMAIN: the fully qualified domain name of the platform (eg.: pryv.me)
- REG_MASTER_IP_ADDRESS: IP address of the master register machine
- CORE_1_IP_ADDRESS (add more if needed): hostname or IP address of the 1st core machine
- CORE_HOSTING_1: name of hosting (or cluster), can be individual per core or contain multiple ones
- STATIC_WEB_IP_ADDRESS: hostname of the static-web machine

#### Optional variables

- SERVICE_WEBSITE_IP_ADDRESS: if used, please provide the IP address of the customer or service website - which should resolve http(s)://${DOMAIN}

The following fields will be available in the [service information](https://api.pryv.com/reference/#service-info) for apps self-configuration:

- PLATFORM_NAME: Service name, example "Pryv Lab"
- SUPPORT_LINK: Link to the web page containing support information
- TERMS_OF_USE_LINK: Link to the web page containing terms and conditions

#### Secrets

All the variables whose value is set as `"SECRET"` will have  - to remove if possible

## Leader-follower keys

For each follower service, you must define a secret for it to authentify when fetching its configuration from the leader service. 

In the Leader service configuration file `${PRYV_CONF_ROOT}/config-leader/conf/config-leader.json`, you will find a map called `followers` with the each follower's secret as key and its `url` and `role` as values as shown below:

```
"followers": {
	"iAgeuao4GaD68oQb3hXAxAZkQ13KWWe0": {
		"url": "https://co1.pryv.me/",
		"role": "core"
	},
	"ciWrIHB3GoNoodoSH5zaulgR48aL5MhO": {
		"url": "https://reg.pryv.me/",
		"role": "reg-master"
	}
}
```

The config we provide comes with a strong key, but you may generate a new one for this if you wish.

For each follower, you will need to set the same key in its configuration file `${PRYV_CONF_ROOT}/config-follower/conf/config-follower.json`. It must be placed in the `leader` map as show below:

```json
"leader": {
    "url": "LEADER_URL",
    "auth": "iAgeuao4GaD68oQb3hXAxAZkQ13KWWe0"
  },
```

Usually, the leader URL will be `https://lead.${DOMAIN}`.

## Slave register machine

If your setup contains two register machines (`reg-master` and `reg-slave`), be sure to set the following platform variables:

* REG_MASTER_VPN_IP_ADDRESS: IP address of master register on a secure line between it and slave register (such as a private network)
* REG_SLAVE_IP_ADDRESS: IP address of slave register machine

Then, also uncomment the ports definition for the redis image of `reg-master`, in `${PRYV_CONF_ROOT}/config-leader/data/reg-master/pryv.yml`. It should look like this afterwards:

```yaml
  redis: 
    image: "pryvsa-docker-release.bintray.io/pryv/redis:1.3.38"
    container_name: pryvio_redis
    networks: 
      - backend
    ports:  # used if reg-slave is defined
      - "REG_MASTER_VPN_IP_ADDRESS:6379:6379"
    volumes: 
      - ./redis/conf/:/app/conf/:ro
      - ./redis/data/:/app/data/
      - ./redis/log/:/app/log/
    restart: always
```

## Pryv.io emails

As explained in the [Emails configuration document](https://api.pryv.com/customer-resources/#documents), the following variables need to be set when activating Pryv.io emails:

- MAIL_FROM_NAME: name of the sender
- MAIL_FROM_ADDRESS: email address of the sender
- MAIL_SMTP_HOST: host of the SMTP server that will be delivering the emails
- MAIL_SMTP_PORT: SMTP port (default is 587)
- MAIL_SMTP_USER: username to authenticate against the SMTP server
- MAIL_SMTP_PASS: password to authenticate against the SMTP server

## SSL certificates

All services use Nginx to terminate inbound HTTPS connections. You should have obtained a wildcard certificate for your domain to that effect. You will need to store that certificate along with the CA chain into the appropriate locations. Please follow this [link](https://www.digicert.com/ssl-certificate-installation-nginx.htm) to find instructions on how to convert a certificate for nginx. 

Your certificate files for the respective roles must be placed on the leader machine in these locations: 
  - `${PRYV_CONF_ROOT}/config-leader/data/${ROLE}/nginx/conf/secret/${DOMAIN}-bundle.crt`
  - `${PRYV_CONF_ROOT}/config-leader/data/${ROLE}/nginx/conf/secret/${DOMAIN}-key.pem`

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

To launch the installation, you will need to SSH to each Pryv.io machine and repeat the commands described below for each machine. Please start with the leader machine (usually on `reg-master`) first and then the follower machines (`cores`, `static`, `reg-slave`).

You will first need to authenticate with the distribution host to retrieve the Pryv.io docker images. You should have received a set of credentials with the delivery of the configuration files. The following assumes that you have a user id (${USER_ID}) and a secret (${SECRET}).

To log in, type: 

    docker login pryvsa-docker-release.bintray.io

You will be prompted for a username and password. Please enter the credentials you were provided.

Once this completes, set the required permissions on data and log directories by running the following script:

    sudo ./ensure-permissions-${ROLE}

On the leader machine only, run the configuration leader service: 

    sudo ./run-config-leader

Then, run the configuration follower service, which will pull the necessary configuration files from the leader:

    sudo ./run-config-follower 

Now that the configuration is ready, you can launch the Pryv.io components:

    sudo ./run-pryv

This command will download the docker images that belong to your release from the docker repository and launch the components. If all goes well, you'll see a number of running docker containers when you start `docker ps`.

### Validation

Please refer to the `Installation validation` document located in the [customer resource documents](https://api.pryv.com/customer-resources/#documents) to validate that your Pryv.io platform is up and running.

### Automatic restart upon configuration update
If you wish to automatically restart pryv components when some configuration update occurs you can watch the configuration files on each machine running a service-config-follower by launching the `watch-config` script (described bellow).
However, it requires you have `fs-watch` installed.
On Ubuntu 18.04 and above you can install it with

    sudo apt install fswatch

On other Linux versions you'll have to compile it yourself following this documentation : https://github.com/emcrisostomo/fswatch#installation
Here is an example on how to do that on Ubuntu 16.04 :

    VERSION=1.14.0;
    
    pushd /tmp;
    
    sudo apt-get update -y;
    sudo apt dist-upgrade;
    sudo apt-get install -y build-essential; # install gcc and other compiling tools
    url="https://github.com/emcrisostomo/fswatch/releases/download/$VERSION/fswatch-$VERSION.tar.gz"
    echo "Downloading $url"
    curl -O -J -L $url --output fswatch-$VERSION.tar.gz;
    tar xzf fswatch-$VERSION.tar.gz;
    cd fswatch-$VERSION;
    ./configure;
    make;
    sudo make install;
    sudo ldconfig;
    
    popd;

When the `watch-config` script is running, any changes in a file under `${PRYV_CONF_ROOT}/pryv/*/conf/` (even a simple `touch`) will trigger the `reload-module` script who will restart all the pryv containers.
In practice these changes will occure when calling the route `https://lead.${DOMAIN}/admin/notify?auth=${ADMIN_KEY}`
The `service-config-follower` will fetch all the configuration files from `service-config-leader` and write them under the `${PRYV_CONF_ROOT}/pryv/` folder, triggering the `watch-config` script.

If you want to automatically restart pryv components upon a configuration update you can launch the `watch-config` script :

    sudo ./watch-config --no-hup

To stop watching :

    sudo ./watch-config --stop-watch


## Closing Remarks

If you need support, please contact your technical account manager @ Pryv or open a ticket on [our helpdesk](https://pryv.com/helpdesk/). We're glad to help you with any questions you might have. 