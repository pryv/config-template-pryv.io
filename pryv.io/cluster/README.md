# Pryv.io configuration template

In the current folder, you will find the template configuration files for a Pryv.io cluster installation.

## Usage

Run `./scripts/build ${CUSTOMER}` to generate configuration tarballs in `tarballs/`.

Distribute them to customer, who will follow the instructions in `INSTALL.md` to install and run the software.

## Adaptations

If you are using a single register machine, remove `REG_MASTER_VPN_IP_ADDRESS` part from the `config-leader/data/reg-master/pryv.yml` file.

If needed, update docker image versions in `config-leader/data/${ROLE}/pryv.yml`.
