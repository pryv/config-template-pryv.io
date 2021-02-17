#!/usr/bin/env bash

set -e

SCRIPT_FOLDER=$(cd $(dirname "$0"); pwd)
cd $SCRIPT_FOLDER/..

# Get Tag

tag=`git describe`
echo $tag

# Set Name

dirName="../../docs/pryv.io/single-node/${tag}"
tarName="pryv.io-${tag}-single-node.tgz"
date=$(date '+%d\/%m\/%Y')

# Build folder

mkdir -p $dirName

# Define files

files="run-config-follower config-follower stop-config-follower restart-config-follower \
  watch-config reload-module \
  config-leader run-config-leader stop-config-leader restart-config-leader \
  pryv run-pryv stop-pryv restart-pryv \
  ensure-permissions \
  upgrades \
  UPDATE-TO-CENTRALIZED.md \
  INSTALL.md UPDATE.md"

# Build tarball

COPYFILE_DISABLE=1 tar -vzcf "${dirName}/${tarName}" \
  --exclude .DS_Store \
  $files

# Append link

indexFile="../../docs/pryv.io/single-node/index.html"
replacement="  <li><a href="${tag}\/${tarName}">${tag} - ${date}<\/a><\/li>"

sed -i '' -e "s,<\/ul>,${replacement},g" $indexFile
echo "</ul>" >> $indexFile