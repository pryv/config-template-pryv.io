#!/usr/bin/env bash

set -e

SCRIPT_FOLDER=$(cd $(dirname "$0"); pwd)
cd $SCRIPT_FOLDER/..


# Get Tag

tag=`git describe`
echo $tag

# Set Name

dirName="../../docs/pryv.io/cluster/${tag}"
tarName="pryv.io-${tag}-cluster.tgz"
date=$(date '+%d\/%m\/%Y')

# Build folder

mkdir -p $dirName

rootDir="tarballs/$tag"

# Define files

commonFiles="config-follower run-config-follower stop-config-follower restart-config-follower \
  watch-config reload-module \
  pryv run-pryv stop-pryv restart-pryv \
  INSTALL.md UPDATE.md \
  upgrades UPDATE-TO-CENTRALIZED.md \
  init-follower"
leaderUrl="https:\/\/lead.DOMAIN"

function build_cores() {
  filesList="$commonFiles ensure-permissions-core"

  for nbr in $(seq $1)
  do
    build "core$nbr" "$filesList" "$leaderUrl"
  done 
}

function build_reg_master() {
  filesList="$commonFiles ensure-permissions-reg-master \
    config-leader run-config-leader stop-config-leader restart-config-leader init-leader"

  build "reg-master" "$filesList" "http:\/\/config-leader:7000"
}

function generate_secret() {
  openssl rand -hex 32
}

function build_reg_slave() {
  filesList="$commonFiles ensure-permissions-reg-slave"

  build "reg-slave" "$filesList" "$leaderUrl"
}

function build_static() {
  filesList="$commonFiles ensure-permissions-static"

  build "static" "$filesList" "$leaderUrl"
}

function replace_leader_url() {
  role=$1
  url=$2
  followerConf="$rootDir/${role}/config-follower/conf/config-follower.json"
  sed -i "" -e "s/LEADER_URL/${url}/g" "$followerConf"
}

function generate_lead_fol_keys() {
  role=$1
  secret=`generate_secret`
  leaderConf="$rootDir/reg-master/config-leader/conf/config-leader.json"
  followerConf="$rootDir/${role}/config-follower/conf/config-follower.json"
  sed -i "" -e "s/FOLLOWER_KEY_${role}/${secret}/g" "$leaderConf"
  sed -i "" -e "s/FOLLOWER_KEY/${secret}/g" "$followerConf"
}

function build() {
  role=$1
  filesList=$2
  leaderUrl=$3
  mkdir -p "$rootDir/$role/" # Create temp folder
  for file in $filesList; do cp -r "$file" "$rootDir/$role/$file"; done
  generate_lead_fol_keys "$role"
  replace_leader_url "$role" "$leaderUrl"
}

function prepare_tar() {
  cd $rootDir
  tarballs=""
  for role in *
  do
    if [[ -d $role ]]; then
      tarball="pryv.io-${tag}-${role}.tgz"
      COPYFILE_DISABLE=1 tar -vzcf "${tarball}" \
        --exclude .DS_Store \
        $role
      rm -r $role # Clean temp folder
      tarballs="${tarballs} ${tarball}"
    fi
  done

  # packagea all role tarballs in one
  COPYFILE_DISABLE=1 tar -vzcf "../../${dirName}/${tarName}" \
    --exclude .DS_Store \
    $tarballs

  cd "../.."
}

build_reg_master # Always build reg-master (leader) first
build_reg_slave
build_cores 2
build_static 

prepare_tar

# Append link

indexFile="../../docs/pryv.io/cluster/index.html"
replacement="  <li><a href="${tag}\/${tarName}">${tag} - ${date}<\/a><\/li>"

sed -i '' -e "s,<\/ul>,${replacement},g" $indexFile
echo "</ul>" >> $indexFile