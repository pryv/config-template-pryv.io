#!/bin/bash
DOMAIN="pryv.li"
SCRIPTS="/app/scripts"
DATA="/app/data"
LETSENCRYPT_DIR="/etc/letsencrypt/archive"
LEADER="http://0.0.0.0:7000"
USERNAME="admin"
PASSWORD="admin"
log="/var/log/renew_cert.log"

function installNecessaryDependencies() {
    apt-get update
    pkgs='certbot'
    if ! dpkg -s $pkgs >/dev/null 2>&1; then
    apt-get -y install $pkgs
    fi
    pkgs='jq'
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
}

function requestCertificate() {
    {
        echo "Y" | certbot certonly --manual --manual-auth-hook $SCRIPTS/hook.js -d *.$DOMAIN --dry-run
    } || {
        echo $(date) Error to create new certificate >> $log
        }
}

function propagateCertificate() {
    directories=`find $DATA -name "secret" -type d`
        echo "$directories" | while read directory; do
            # When acknowledged, put fullchain.pem > pryv.li-bundle.crt and privkey.pem > pryv.li-key.pem
            cp $LETSENCRYPT_DIR/$DOMAIN/test_renew.crt $directory/test.crt
            echo "$directory"
        done

        token=`curl -s -X POST -H "Content-Type: application/json" -d "{\"username\": \"$USERNAME\", \"password\": \"$PASSWORD\"}" $LEADER/auth/login | \
        jq '.token' | tr -d '"'`
        curl -X POST -H "Authorization: $token" $LEADER/admin/notify
}

function checkCertificateFollowers() {
    followers=`jq '.followers[].url' /app/conf/config-leader.json`
        echo "$followers" | while read follower; do
        follower=`tr -d '"' <<< "$follower"`
        if [[ $follower == https://* ]];then
            follower=`echo ${follower:(8)}`
            echo | openssl s_client -servername $follower -connect $follower:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $LETSENCRYPT_DIR/tmp.crt
            if cmp -s $LETSENCRYPT_DIR/tmp.crt $LETSENCRYPT_DIR/$DOMAIN/cert.pem; then
                echo $(date) Success: $follower did receive the certificate >> $log
            else
                echo $(date) Error: $follower did not receive the certificate >> $log
            fi
        fi
    done
}

set -e

if (([ ! -f $LETSENCRYPT_DIR/$DOMAIN/fullchain.pem ] || [ ! -f $LETSENCRYPT_DIR/$DOMAIN/privkey.pem ]) || \
([ $(echo "$((($(echo | openssl x509 -enddate -noout -in $LETSENCRYPT_DIR/$DOMAIN/fullchain.pem| sed 's/^.\{9\}//' | date  -f - '+%s') - $(date '+%s'))/43200))") -lt 30 ])); then
    cp -rf $LETSENCRYPT_DIR/$DOMAIN $LETSENCRYPT_DIR/tmp/$DOMAIN
    installNecessaryDependencies
    requestCertificate

    date=`date "+%Y%m%d"`
    datePriv=`date -r "$LETSENCRYPT_DIR/$DOMAIN/fullchain.pem" "+%Y%m%d"`|| echo $(date) Error: $LETSENCRYPT_DIR/$DOMAIN/privkey.pem does not exist >> $log
    datePriv=`date -r "$LETSENCRYPT_DIR/$DOMAIN/privkey.pem" "+%Y%m%d"`|| echo $(date) Error: $LETSENCRYPT_DIR/$DOMAIN/privkey.pem does not exist >> $log
    if ([ -f "$LETSENCRYPT_DIR/$DOMAIN/fullchain.pem" ] && [ "$date" == "$dateFull" ] && [ -f "$LETSENCRYPT_DIR/$DOMAIN/privkey.pem" ] && [ "$date" == "$datePriv" ]); then
        propagateCertificate
        checkCertificateFollowers

    else
        rm -rf $LETSENCRYPT_DIR/$DOMAIN
        cp -rf $LETSENCRYPT_DIR/tmp/$DOMAIN $LETSENCRYPT_DIR/$DOMAIN
        echo $(date) Error: Certificates are not new >> $log
    fi
        rm -rf $LETSENCRYPT_DIR/tmp/$DOMAIN
fi