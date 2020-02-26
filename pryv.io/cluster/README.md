# Pryv.io configuration template

In the current folder, you will find the template configuration files for a Pryv.io cluster installation.

## Usage

Run `./scripts/build ${CUSTOMER}` to generate configuration tarballs in `tarballs/`.

Distribute them to customer, who will follow the instructions in `INSTALL.md` to install and run the software.

## Adaptations

If you are using two register machines, uncomment the `REG_MASTER_VPN_IP_ADDRESS` part from the `config-leader/data/reg-master/pryv.yml` file.

If needed, update docker image versions in `config-leader/data/${ROLE}/pryv.yml`.

## Sync-to-remote script

The script to sync configuration files to remote machines should be run with one of the following modes:

  * **followers**: sync service-follower configuration files and corresponding startup scripts to all machines (cores, regs, sw)
  * **leader**: sync service-leader configuration files and corresponding startup scripts as well as the full platform configuration template to reg-master 
  * **logrotate**: sync various additional files such as logrotate configurations to all machines (cores, regs, sw) 
  * **certs**: backup (in /certs/backup) old SSL certificates from reg-master then push new certifactes (place them in /certs) for all machines in the leader (reg-master).
