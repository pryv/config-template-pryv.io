#!/usr/bin/env bash

# the first argument should be the folder to copy and the second one the destination similar to scp
# ex.: sync-files.sh reg/ kebetsi@12.13.14.15:/var/pryv/reg

rsync -av $1 $2