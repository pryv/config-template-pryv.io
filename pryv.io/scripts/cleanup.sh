#!/usr/bin/env bash

# cleans up files generated when running the container locally

rm core/mongodb/data/WiredTiger*
rm core/mongodb/data/_mdb_catalog.wt
rm core/mongodb/data/collection-*
rm -r core/mongodb/data/diagnostic.data
rm -r core/mongodb/data/index-*
rm -r core/mongodb/data/journal
rm -r core/mongodb/data/mongod.lock
rm -r core/mongodb/data/sizeStorer.wt
rm -r core/mongodb/data/storage.bson
rm -r core/mongodb/log/mongodb.log
rm -r core/nginx/log/*
rm -rf core/nginx/log/*
