#!/bin/bash
DOMAIN="pryv.li"
SCRIPTS="/app/scripts"
DATA="/app/data"
LETSENCRYPT_DIR="/etc/letsencrypt/archive"
LEADER="http://0.0.0.0:7000"
USERNAME="admin"
PASSWORD="admin"
log="/var/log/renew_cert.log"
set -e
if (([ ! -f $LETSENCRYPT_DIR/$DOMAIN/fullchain.pem ] || [ ! -f $LETSENCRYPT_DIR/$DOMAIN/privkey.pem ]) || \
([ $(echo "$((($(echo | openssl x509 -enddate -noout -in $LETSENCRYPT_DIR/$DOMAIN/fullchain.pem| sed 's/^.\{9\}//' | date  -f - '+%s') - $(date '+%s'))/43200))") -lt 30 ] && \
[ $(echo "$((($(echo | openssl x509 -enddate -noout -in $LETSENCRYPT_DIR/$DOMAIN/privkey.pem| sed 's/^.\{9\}//' | date  -f - '+%s') - $(date '+%s'))/43200))") -lt 30 ])); then
    echo $DOMAIN
    cp -rf $LETSENCRYPT_DIR/$DOMAIN $LETSENCRYPT_DIR/tmp/$DOMAIN
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

    {
        echo "Y" | certbot certonly --manual --manual-auth-hook $SCRIPTS/hook.js -d *.$DOMAIN --dry-run
    } || {
        echo $(date) Error to create new certificate >> $log
        }

    date=`date "+%Y%m%d"`
    dateCert=`echo | openssl x509 -enddate -noout -in $LETSENCRYPT_DIR/$DOMAIN/cert.pem| sed 's/^.\{9\}//' | date  -f - "+%Y%m%d"` || echo $(date) Error: $LETSENCRYPT_DIR/$DOMAIN/cert.pem does not exist >> $log
    dateFull=`date -r "$LETSENCRYPT_DIR/$DOMAIN/fullchain.pem" "+%Y%m%d"` || echo $(date) Error: $LETSENCRYPT_DIR/$DOMAIN/fullchain.pem does not exist >> $log
    datePriv=`date -r "$LETSENCRYPT_DIR/$DOMAIN/privkey.pem" "+%Y%m%d"`|| echo $(date) Error: $LETSENCRYPT_DIR/$DOMAIN/privkey.pem does not exist >> $log
    if ([ -f "$LETSENCRYPT_DIR/$DOMAIN/fullchain.pem" ] && [ "$date" == "$dateFull" ] && [ -f "$LETSENCRYPT_DIR/$DOMAIN/privkey.pem" ] && [ "$date" == "$datePriv" ] && \
    [ "$date" == "$dateCert" ]); then
        directories=`find $DATA -name "secret" -type d`
        echo "$directories" | while read directory; do
            # When acknowledged, put fullchain.pem > pryv.li-bundle.crt and privkey.pem > pryv.li-key.pem
            cp $LETSENCRYPT_DIR/$DOMAIN/test_renew.crt $directory/test.crt
            echo "$directory"
        done

        token=`curl -s -X POST -H "Content-Type: application/json" -d "{\"username\": \"$USERNAME\", \"password\": \"$PASSWORD\"}" $LEADER/auth/login | \
        jq '.token' | tr -d '"'`
        curl -X POST -H "Authorization: $token" $LEADER/admin/notify

        followers=`jq '.followers[].url' /app/conf/config-leader.json`
        echo "$followers" | while read follower; do
            follower=`tr -d '"' <<< "$follower"`
            if [[ $follower == https://* ]];then
                follower=`echo ${follower:(8)}`
                echo | openssl s_client -servername $follower -connect $follower:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $LETSENCRYPT_DIR/tmp.crt
                if cmp -s $LETSENCRYPT_DIR/tmp.crt $LETSENCRYPT_DIR/$DOMAIN/cert.pem; then
                    echo "Success $follower"
                else
                    echo "Failure $follower"
                fi
            fi
        done

    else
        rm -rf $LETSENCRYPT_DIR/$DOMAIN
        cp -rf $LETSENCRYPT_DIR/tmp/$DOMAIN $LETSENCRYPT_DIR/$DOMAIN
        echo $(date) Error: Certificates are not new >> $log
    fi
        rm -rf $LETSENCRYPT_DIR/tmp/$DOMAIN
fi
# echo | openssl s_client -servername adm.pryv.li -connect adm.pryv.li:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $LETSENCRYPT_DIR/tmp.crt
# echo | openssl x509 -enddate -noout -in /etc/letsencrypt/archive/pryv.li/cert.pem| sed 's/^.\{9\}//' | date  -f - '+%s'