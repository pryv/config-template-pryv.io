# Pryv.io update guide

This guide contains instructions to update a Pryv.io single-node platform.

Check the `upgrades/` folder to see if you have any additionnal steps to perform.

1. Backup all your files in PRYV_CONF_ROOT for rollback in case of failure: tar czfv `date "+%F"`-pryv-backup.tgz ${PRYV_CONF_ROOT}
2. Untar new template in PRYV_CONF_ROOT: `tar xzfv ${CONFIG_TARBALL} -C ${PRYV_CONF_ROOT} --strip-components=1 --overwrite --same-owner`
3. Reboot the config-leader service: `restart-config-leader`
4. Sign in the admin panel. If you had Pryv.io version older than 1.7, your admin panel does not have the migrations UI, please use: https://api.pryv.com/app-web-admin/?pryvLeaderUrl=https://lead.${DOMAIN}, otherwise use: https://adm.${DOMAIN}. Sign in, go to "Platform Configuration", click on "Find migrations" and if you are OK with the available upgrades, press "Apply migrations" which will migrate the `platform.yml` contents to the newest format.
Upon successful migration, the message "No available migration" should be displayed
5. Press "Update" to apply the reboot all follower services with the new configuration.
6. Validate using "Installation validation" guide: https://api.pryv.com/customer-resources/platform-validation/
