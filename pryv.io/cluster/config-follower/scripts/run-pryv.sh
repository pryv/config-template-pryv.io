#!/bin/bash

#This script will be called by config-follower through the pipe
set -e

echo "currently in $(pwd)" > "$1" # for debugging purpose
echo "./run-pryv" > "$1"
echo "exit" > "$1" # leave the tail -f
