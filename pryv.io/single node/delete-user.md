# Delete Pryv.io users

## Summary

In this document, we present a tool which allows to delete Pryv.io users;
**pryv-cli delete-user**.

This deletion command is meant to run on a Pryv.io 'core' machine,
and has the effect of removing all user data, namely:

  - MongoDB collections (accesses, events, streams, followedSlices, profile, user)
  - Attachments and previews files
  - InfluxDB time series (high frequency measurements)
  - User entry on 'register' machine

## Setup

The easiest way to run **pryv-cli** is through a docker container. To make this 
easier in day to day life, here's a useful shell alias: 

```shell
$ alias pryv-cli='docker run --read-only \
  -v ${PRYVIO_CORE_CONF_DIR}:/app/conf/:ro \
  -v ${PRYVIO_CORE_DATA_DIR}:/app/data/ \
  --network ${DOCKER_BACKEND_NETWORK} -ti \
  pryvsa-docker-release.bintray.io/pryv/cli:${PRYVIO_CLI_LATEST_VERSION} $*'
```

The 'core' machine should have a configuration directory where all Pryv.io
configuration files reside. The alias above assume that these files are located
in the folder `PRYVIO_CORE_CONF_DIR`.

Similarly, we refer to the path where the 'core' machine holds Pryv.io data
as `PRYVIO_CORE_DATA_DIR`.

Now, run this command to find the backend network bridge for the Pryv.io installation:

```shell
$ docker network ls
```

This will list a few networks; the network you're looking for combines the 
name for your installation with the postfix '**_backend**'.
We refer to this network as `DOCKER_BACKEND_NETWORK`.

Finally, make sure that the version of the pryv/cli docker image you are using,
refered to as `PRYVIO_CLI_LATEST_VERSION`, matches the one of the pryv/core
docker image currently deployed (you can check by running `docker ps`).

Here is a concrete example of a pryv-cli alias for a **single node** Pryv.io platform
(at the time of writing, pryv/core and pryv/cli were in version 1.3.53) :

```shell
$ alias pryv-cli='docker run --read-only \
  -v /var/pryv/pryv.io/pryv/:/app/conf/:ro \
  -v /var/pryv/pryv.io/pryv/core/data/:/app/data/ \
  --network pryvio_backend -ti \
  pryvsa-docker-release.bintray.io/pryv/cli:1.3.53 $*'
```

## Usage

As soon as the alias is set up, you can invoke **pryv-cli** like so: 

```shell
$ pryv-cli -h
```

To remove a Pryv.io user, use the following command:

```shell
$ pryv-cli delete-user <username>
```

The first time you run it, it will download the docker image from the distribution
platform; all subsequent runs will be instant. 

We further assume that you hold a valid Pryv.io license and that you're 
authorised to operate on the machine. Some operations - especially deleting 
users - are permanent. Please exercise proper care. 
