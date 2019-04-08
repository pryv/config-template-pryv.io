# Delete Pryv.io users

## Summary

In this document, we present a tool which allows to delete Pryv.io users:
**pryv-cli delete-user**.

This deletion command is meant to run on a Pryv.io 'core' machine, and has the effect of removing all user data, namely:

  - MongoDB collections (accesses, events, streams, followedSlices, profile, user)
  - Attachments and previews files
  - InfluxDB time series (high frequency measurements)
  - User entry on 'register' machine

## Setup

The easiest way to run **pryv-cli** is through a docker container. To make this easier, we suggest to define the following shell alias: 

```shell
$ alias pryv-cli='docker run --read-only \
  -v ${PRYV_CONF_ROOT}/core/:/app/conf/:ro \
  -v ${PRYV_CONF_ROOT}/core/core/data/:/app/data/ \
  --network ${DOCKER_BACKEND_NETWORK} -ti \
  pryvsa-docker-release.bintray.io/pryv/cli:${PRYVIO_CORE_VERSION} $*'
```

The 'core' machine should have a directory where all Pryv.io configuration files reside. The alias above assume that these files are located in the folder `PRYV_CONF_ROOT`.

Now, run this command to find the name of `${DOCKER_BACKEND_NETWORK}` for your Pryv.io installation:

```shell
$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
b31ec5197df9        bridge              bridge              local
b5f5dc7e7bec        host                host                local
8811ef2345c1        none                null                local
3367ee3c2c52        pryv_backend        bridge              local
b4d0330a724e        pryv_frontend       bridge              local
```

This will list a few networks; the network you are looking for combines the name of the `${PRYV_CONF_ROOT}` directory with the postfix '**_backend**'. In the example above, it is `pryv_backend`. We refer to this network as `${DOCKER_BACKEND_NETWORK}`.

Finally, make sure that the version of the `pryv/cli` docker image you are using, refered to as `{PRYVIO_CORE_VERSION}`, matches the one of the `pryv/core` docker image currently deployed (you can check by running `docker ps`).

```shell
$ docker ps
...
885a22dddd46        pryvsa-docker-release.bintray.io/pryv/core:1.3.53
...
```

Here is a concrete example of a pryv-cli alias command for a **cluster** Pryv.io platform (at the time of writing, `pryv/core` and `pryv/cli` were in version 1.3.53) :

```shell
$ alias pryv-cli='docker run --read-only \
  -v /var/pryv/core/:/app/conf/:ro \
  -v /var/pryv/core/core/data/:/app/data/ \
  --network pryv_backend -ti \
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

The first time you run it, it will download the docker image from the distribution platform; all subsequent runs will execute immediately. 

We further assume that you hold a valid Pryv.io license and that you're authorised to operate on the machine. Some operations - especially deleting users - are permanent. Please exercise proper care. 
