# Pryv.io configuration template

In the current folder, you will find the template configuration files for a Pryv.io singlenode installation.

## Usage

Run `./scripts/build ${CUSTOMER}` to generate configuration tarballs in `tarballs/`.

Distribute them to customer, who will follow the instructions in `INSTALL.md` to install and run the software.

## Troubleshoot

### Permission denied

`error: [config-follower:server] Error: EACCES: permission denied, mkdir '/app/pryv/audit'`

On MacOS, there is a permissions issue that prevents *config-follower* from creating the folder structure it retrieves from the leader. You should therefore copy the structure by hand: `sudo cp -R config-leader/data/singlenode/* pryv`