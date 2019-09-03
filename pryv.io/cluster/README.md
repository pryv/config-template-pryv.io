# Pryv.io configuration template

In the data folder of the configuration leader service (config-leader/data/), you will find the template configuration files for a Pryv.io cluster installation.

## Usage

1. Replace the [platform-specific variables](#variables).
2. If you are using a single register machine, remove `REG_MASTER_VPN_IP_ADDRESS` part from the `config-leader/data/reg-master/pryv.yml` file.
3. If needed, update docker image versions in `config-leader/data/{role}/pryv.yml`.
4. Generate tarballs in `tarballs/` from config files using `./scripts/build ${DOMAIN}`.
5. Follow the instructions in `INSTALL.md` to install and run the software.

### Variables

These values need to be replaced in the config-leader configuration (in /config-leader/conf/config-leader.json), within the 'platform' object.
If possible, obtain these from the customer to do the replace operation.

* DOMAIN: the domain of the platform (eg.: pryv.me)
* CORE_SYSTEM_KEY: key to make system calls on cores
* REGISTER_SYSTEM_KEY_1: key to make system calls on register
* REGISTER_ADMIN_KEY_1: key to make admin calls on register
* STATIC_WEB_IP_ADDRESS: hostname of static-web machine
* REG_MASTER_IP_ADDRESS: IP address of master register machine
* REG_MASTER_VPN_IP_ADDRESS: IP address of master register on a secure line between it and slave register (can be a private network)
* REG_SLAVE_IP_ADDRESS: IP address of slave register machine
* CORE_1_IP_ADDRESS (add more if needed): hostname or IP address of core machine
* CORE_HOSTING_1: name of hosting (or cluster), can be individual per core or contain many
* OVERRIDE_ME: single appearance values that need to be replaced with a strong key

#### optional variables

* SERVICE_WEBSITE_IP_ADDRESS: if exists, please provide the IP address of the customer or service website - where to redirect from http://DOMAIN

These fields will be available in https://reg.DOMAIN/service/infos

* PLATFORM_NAME: field `name`
* SUPPORT_LINK: ield `support`
* TERMS_OF_USE_LINK: ield `terms`