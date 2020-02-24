DNS_DOM="*.DOMAIN"
EMAIL="tech@pryv.com"
AUTH_SCRIPT="./post-record-from-container.sh"
CLEANUP_SCRIPT="./cleanup.sh"

sudo certbot certonly --domain $DNS_DOM \
    --email $EMAIL \
    --preferred-challenges dns-01 \
    --manual-public-ip-logging-ok \
    --manual \
    --manual-auth-hook $AUTH_SCRIPT \
    --manual-cleanup-hook $CLEANUP_SCRIPT \
    --agree-tos
