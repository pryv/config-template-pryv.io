# Pryv.io update guide

This guide contains instructions to update a Pryv.io single-node platform.

Check the `upgrades/` folder to see if you have any additionnal steps to perform.

1. Backup all your files: `tar czfv `date "+%F"`-pryv-backup.tgz ${PRYV_CONF_ROOT}` for rollback in case of failure
2. Backup platform parameters and keys:

  - `${PRYV_CONF_ROOT}/config-leader/conf/platform.yml`
  - `${PRYV_CONF_ROOT}/config-leader/conf/config-leader.json`
  - `${PRYV_CONF_ROOT}/config-follower/conf/config-follower.json`
  
3. Untar new template in PRYV_CONF_ROOT: `tar xzfv ${CONFIG_TARBALL} -C ${PRYV_CONF_ROOT} --strip-components=1 --overwrite`
4. If needed, add new values in your `platform.yml`, `config-leader.json` & `config-follower.json` files. Use `diff` to find new values.
5. Replace the template platform config files with your backed up ones
6. Reboot services, starting with reg-master
  6.1 leader: `./restart-config-leader`
  6.2 follower: `./restart-config-follower`
  6.3 Pryv.io: `./restart-pryv`
7. Validate: See "Installation validation" in https://api.pryv.com/customer-resources/#documents
