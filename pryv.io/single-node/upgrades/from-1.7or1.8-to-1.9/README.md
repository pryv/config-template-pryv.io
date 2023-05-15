# Mongo DB upgrade from 1.7 or 1.8 to 1.9 

In Pryv 1.9 MongoDB 6.0 is used and requires a migration with a `mongodump` => `mongorestore` steps 

1. Before upgrading Pryv.io, from directory `${PRYV_CONF_ROOT}`
    1. shutdown pryv
        `./stop-pryv`
  2. start mongodb only 
       `docker-compose -f ${PRYV_CONF_ROOT}/pryv/pryv.yml pryvio_mongodb up`
  3. make sure there is no exsiting backup in `${PRYV_CONF_ROOT}/pryv/mongodb/backup` as the content will be overwritten in the next step. Eventually move it.
  4. make a backup of mongodb content
        `docker exec -t pryvio_mongodb /app/bin/mongodb/bin/mongodump -d pryv-node -o /app/backup/`  
  5. stop mongodb 
       `docker stop pryvio_mongodb`
  6. Move mongodb raw data to a backup directory example
       `export MONGOBKP=/var/pryv/mongo_raw_bkp_4.2/`
       `mkdir $MONGOBKP`
       `mv ${PRYV_CONF_ROOT}/pryv/mongodb/data/* $MONGOBKP`
  7. Upgarde to v1.9.0 without starting pryv
  8. start mongodb only 
       `docker-compose -f ${PRYV_CONF_ROOT}/pryv/pryv.yml pryvio_mongodb up`
  9. Restore the backup created with mongodump
       `docker exec -t pryvio_mongodb /app/bin/mongodb/bin/mongorestore /app/backup/`
  10. start pryv