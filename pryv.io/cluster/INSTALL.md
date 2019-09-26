# Installation guide

This guide contains instructions for a Pryv.io cluster installation.
You should have prepared your machines with the [Deployment Design Guide](https://api.pryv.com/customer-resources/#documents) first. 
    
## Configuration Install

The instructions below need to be repeated for each of machine that
is part of your configuration. You should have received several configuration
files, one for each role: 'static', 'reg-master', 'reg-slave', 'core'. We'll use the placeholder
${ROLE} to refer to these roles below.

Please create a directory where all your Pryv data should live. We suggest something like `'/var/pryv'`. For the purposes of this document, we'll refer to that location as `${PRYV_CONF_ROOT}`. Then follow these steps: 

  * Copy the configuration tarball to the root of the directory. 
  * Untar the configuration in place.  

You should have the three following entries now: 

  * A file called `ensure-permissions-${ROLE}`. This script ensures that the correct 
    permissions are set for data and log directories.
  * The file `run-config-leader` and folder `config-leader`. This is the script and configuration files that are used to launch the configuration leader service. The leader is usually hosted on the `reg-master` machine.
  * The file `run-config-follower` and folder `config-follower`. This is the script and configuration files that are used to launch the configuration follower service. There should be one follower service on each machine.
  * A file called `run-pryv`. This is your startup script. 
  * A directory called `pryv`. This will contain configuration and data
    directories that will be mapped as volumes in the various docker 
    containers.
  * The files `stop-config-leader`, `stop-config-leader` and `stop-pryv`. These scripts stop the corresponding running services.

## Completing the Configuration

### Leader-follower setup

The configuration leader service will distribute the necessary configuration files for your Pryv.io platform to the configuration follower services.

Followers can be declared through the leader configuration (`${PRYV_CONF_ROOT}/config-leader/conf/config-leader.json`) within a `followers` map, for example:

```
  "adminKey": "lDng9YLK3v57A8V6awdeLuaY2eaHmB7N",
  "followers": {
    "iAgeuao4GaD68oQb3hXAxAZkQ13KWWe0": {
      "url": "http://co1.pryv.me",
      "role": "core"
    },
    "ciWrIHB3GoNoodoSH5zaulgR48aL5MhO": {
      "url": "http://reg.pryv.me",
      "role": "reg-master"
    }
  }
```

Each follower in this map is indexed by a symmetric key that you can change, and also specifies its role (core, reg-master, reg-slave, static) and url.

An `adminKey` must also be configured for the leader, it will be useful for platform administrators in order to interact with the leader remotely.

In each follower configuration (`${PRYV_CONF_ROOT}/config-follower/conf/config-follower.json`), the corresponding symmetric key is provided (as defined above in the leader) as well as the leader url (usually `https://lead.${DOMAIN}`), as follows:

```
  "leader": {
    "url": "https://lead.pryv.me",
    "auth": "iAgeuao4GaD68oQb3hXAxAZkQ13KWWe0"
  }
```

### Platform variables

The configuration leader service is hosting the template configuration files for a Pryv.io installation in the `config-leader/data/` folder. It will adapt this template before distributing final configuration files to the follower services, according to the platform-specific variables that you should define in `${PRYV_CONF_ROOT}/config-leader/conf/config-leader.json`.

Here is a list of the required platform-specific variables:

* DOMAIN: the domain of the platform (eg.: pryv.me)
* STATIC_WEB_IP_ADDRESS: hostname of static-web machine
* REG_MASTER_IP_ADDRESS: IP address of master register machine
* CORE_1_IP_ADDRESS (add more if needed): hostname or IP address of core machine
* CORE_HOSTING_1: name of hosting (or cluster), can be individual per core or contain many

#### Secrets

Additionally, there are several secret keys that need to be set. We recommand to generate your own secret keys.
Alternatively, if you leave their value to "SECRET", the configuration leader service will generate a random key for each of them.

* SSO_COOKIE_SIGN_SECRET: salt used to generate SSO cookie signature
* FILES_READ_TOKEN_SECRET: salt used to generate read tokens for attachments
* CORE_SYSTEM_KEY: key to make system calls on cores
* REGISTER_SYSTEM_KEY_1: key to make system calls on register
* REGISTER_ADMIN_KEY_1: key to make admin calls on register

#### Optional variables

* SERVICE_WEBSITE_IP_ADDRESS: if exists, please provide the IP address of the customer or service website - where to redirect from http://${DOMAIN}

The following fields will be available in https://reg.DOMAIN/service/infos:

* PLATFORM_NAME: field `name`
* SUPPORT_LINK: field `support`
* TERMS_OF_USE_LINK: field `terms`

#### Pryv.io emails

As explained in the [Emails configuration document](https://api.pryv.com/customer-resources/#documents), the following fields need to be set only when activating Pryv.io emails:

* MAIL_FROM_NAME: name of the sender
* MAIL_FROM_ADDRESS: email address of the sender
* MAIL_SMTP_HOST: host of the SMTP server that will be delivering the emails
* MAIL_SMTP_PORT: SMTP port (default is 587)
* MAIL_SMTP_USER: username to authenticate against the SMTP server
* MAIL_SMTP_PASS: password to authenticate against the SMTP server

### Slave register machine

If your setup contains two register machines (reg-master and reg-slave), be sure to set the following platform variables:

* REG_MASTER_VPN_IP_ADDRESS: IP address of master register on a secure line between it and slave register (can be a private network)
* REG_SLAVE_IP_ADDRESS: IP address of slave register machine

Then, also uncomment the ports definition for the redis image of reg-master, in `${PRYV_CONF_ROOT}/config-leader/data/reg-master/pryv.yml`. It should look like this afterwards:

```
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

### SSL certificates

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

To launch the installation, you will need to SSH to each Pryv.io machine and repeat the commands described below for each machine. Please start with the leader machine (reg-master) first and then the follower machines (cores, static, reg-slave).

You will first need to log in to the distribution host for the Pryv docker images. You should have received a set of credentials with the delivery of the configuration files. The following assumes that you have a user id (${USER_ID}) and a secret (${SECRET}).

To log in, type: 

    $ docker login pryvsa-docker-release.bintray.io

You will be prompted for a username and password. Please enter the credentials you were provided.

Once this completes, set the required permissions on data and log directories by running the following script:

    $ sudo ./ensure-permissions-${ROLE}

On the leader machine only, run the configuration leader service: 

    $ sudo ./run-config-leader

Then, run the configuration follower service, which will pull the necessary configuration files from the leader:

  $ sudo ./run-config-follower

Now that the configuration is ready, you can launch the Pryv.io components:

  $ sudo ./run-pryv

This command will download the docker images that belong to your release from the docker repository and launch the components. If all goes well, you'll see a number of running docker containers when you start `docker ps`.

### Automatic restart upon configuration update
If you wish to automatically restart pryv components when some configuration update occurs you can watch the configuration files on each machine running a service-config-follower by launching the `watch-config` script (described bellow).
However, it requires you have `fs-watch` installed.
On Ubuntu 18.04 and above you can install it with

    $ sudo apt install fswatch

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

    $ sudo ./watch-config --no-hup

To stop watching :

    $ sudo ./watch-config --stop-watch


## Closing Remarks

You should now have a working docker installation. You can test this by directing a browser at [https://sw.${DOMAIN}/access/register.html](https://sw.${DOMAIN}/access/register.html) and filling in the form. 

If you need support, please contact your account manager @ Pryv. We're glad to help you with any questions you might have. 
