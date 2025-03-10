# Pryv.io cluster update guide

This guide contains instructions to update a Pryv.io cluster platform.

Check the `upgrades/` folder to see if you have any additional steps to perform.

First, on each machine:

1. Backup all your files in `PRYV_CONF_ROOT` for rollback in case of failure:
   ```
   ${PRYV_CONF_ROOT}/stop-pryv
   tar czfv `date "+%F"`-pryv-backup.tgz ${PRYV_CONF_ROOT}
   ${PRYV_CONF_ROOT}/run-pryv
   ```
2. Untar new template in `PRYV_CONF_ROOT`:
   ```
   tar xf ${CONFIG_TARBALL}
   ```
3. Untar appropriate template for machine role:
   ```
   tar xzfv ${CONFIG_TARBALL} -C ${PRYV_CONF_ROOT} --strip-components=1 --overwrite --same-owner
   ```
4. If needed, add new parameters to `config-follower/conf/config-follower.json` from `config-follower/conf/template-config-follower.json`
5. Reboot the config-follower service: `restart-config-follower`

Then on the reg-master machine:

1. If needed, add new parameters to `config-leader/conf/config-leader.json` from `config-leader/conf/template-config-leader.json`
2. Reboot the config-leader service: `restart-config-leader`
3. Sign in the admin panel. If you had Pryv.io version older than 1.7, your admin panel does not have the migrations UI, please use: `https://api.pryv.com/app-web-admin/?pryvLeaderUrl=https://lead.${DOMAIN}`, otherwise use: `https://adm.${DOMAIN}`. Sign in, go to "Platform Configuration", click on "Find migrations" and if you are OK with the available upgrades, press "Apply migrations" which will migrate the `platform.yml` contents to the newest format.
Upon successful migration, the message "No available migration" should be displayed
4. Press "Update" to apply the reboot all follower services with the new configuration.
5. Validate using "Installation validation" guide: https://api.pryv.com/customer-resources/platform-validation/
