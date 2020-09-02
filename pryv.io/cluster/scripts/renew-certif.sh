#!/bin/bash
DOMAIN="pryv.li"
SCRIPTS="/app/scripts"
DATA="/app/data"
LETSENCRYPT_DIR="/etc/letsencrypt/archive"
LEADER="http://0.0.0.0:7000"
USERNAME="admin"
PASSWORD="admin"

if (([ ! -f $LETSENCRYPT_DIR/$DOMAIN/fullchain.pem ] || [ ! -f $LETSENCRYPT_DIR/$DOMAIN/privkey.pem ]) || \
([ $(echo "$((($(date '+%s')-$(date -r $LETSENCRYPT_DIR/$DOMAIN/fullchain.pem '+%s'))/43200))") -gt 60 ] && \
[ $(echo "$((($(date '+%s')-$(date -r $LETSENCRYPT_DIR/$DOMAIN/privkey.pem '+%s'))/43200))") -gt 60 ])); then
    mkdir -p $LETSENCRYPT_DIR/tmp/$DOMAIN
    cp -f $LETSENCRYPT_DIR/$DOMAIN $LETSENCRYPT_DIR/tmp/$DOMAIN
    apt-get update
    pkgs='certbot'
    if ! dpkg -s $pkgs >/dev/null 2>&1; then
    apt-get -y install $pkgs
    fi
    pkgs="dnsutils"
    if ! dpkg -s $pkgs >/dev/null 2>&1; then
    apt-get -y install $pkgs
    fi
    package='yamljs'
    if [ `npm list | grep -c $package` -eq 0 ]; then
        npm install $package --no-shrinkwrap
    fi
    package='request'
    if [ `npm list | grep -c $package` -eq 0 ]; then
        npm install $package --no-shrinkwrap
    fi

    echo "Y" | certbot certonly --manual --manual-auth-hook $SCRIPTS/hook.js -d *.$DOMAIN --dry-run

    directories=`find $DATA -name "secret" -type d`
    date=`date "+%Y%m%d"`
    dateFull=`date -r "$LETSENCRYPT_DIR/$DOMAIN/fullchain.pem" "+%Y%m%d"`
    datePriv=`date -r "$LETSENCRYPT_DIR/$DOMAIN/privkey.pem" "+%Y%m%d"`
    if ([ -f "$LETSENCRYPT_DIR/$DOMAIN/fullchain.pem" ] && [ "$date" == "$dateFull" ] && [ -f "$LETSENCRYPT_DIR/$DOMAIN/privkey.pem" ] && [ "$date" == "$datePriv" ]); then
        echo "$directories" | while read directory; do
            # When acknowledged, put fullchain.pem > pryv.li-bundle.crt and privkey.pem > pryv.li-key.pem
            cp $LETSENCRYPT_DIR/$DOMAIN/test_renew.crt $directory/test.crt
            echo "$directory"
        done
        token=`curl -s -X POST -H "Content-Type: application/json" -d "{\"username\": \"$USERNAME\", \"password\": \"$PASSWORD\"}" $LEADER/auth/login | \
        python3 -c "import sys, json; print(json.load(sys.stdin)['token'])"`
        curl -X POST -H "Authorization: $token" $LEADER/admin/notify
    fi
fi