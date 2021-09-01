# Pryv.io update guide

This guide contains instructions to update a Pryv.io cluster platform.

Check the `upgrades/` folder to see if you have any additionnal steps to perform.

1. Backup all your files: `tar czfv` date "+%F"`-pryv-backup.tgz ${PRYV_CONF_ROOT}` for rollback in case of failure
2. Untar new template in PRYV_CONF_ROOT: `tar xzfv ${CONFIG_TARBALL} -C ${PRYV_CONF_ROOT} --strip-components=1 --overwrite`
3. Sign in the admin panel (https://adm.${DOMAIN}), go to "Platform Configuration", click on "Find upgrades" and if you are OK with the available upgrades, press "Apply upgrade" which will migrate the `platform.yml` contents to the newest format.
4. Press update to apply the reboot all follower services with the new configuration.
5. Validate: See "Installation validation" in https://api.pryv.com/customer-resources/#documents
