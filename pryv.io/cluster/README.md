# Pryv.io configuration template

In the current folder, you will find the template configuration files for a Pryv.io cluster installation.

## Usage

1. Replace the [platform-specific variables](#variables) files within this directory.
2. In `pryv.io/static/nginx/conf/site.conf`, change the proxying for route `/access/` to `https://pryv.github.io/app-web-auth2/DOMAIN/`.
3. On the [app-web-auth2 repository gh-pages branch](https://github.com/pryv/app-web-auth2/), create a symlink to the latest version named `DOMAIN`. Or tell the customer to fork the repository, make a push on the `#gh-pages` branch and create the link there. You should then set the proxying in point 6 to `https://CUSTOMER.github.io/app-web-auth2/DOMAIN/`
4. If needed, update docker image versions in `pryv.io/{core,reg,static}.yml`.
5. Generate tarballs from config files using `./scripts/build ${DOMAIN}`.
6. Follow the instructions in `pryv.io/INSTALL.md` to install and run the software on the dedicated machines.

### Variables

These values need to be replaced in the configuration. If possible, obtain these from the customer to do the replace operation.

* DOMAIN: the domain of the platform (eg.: pryv.me)
* CORE_SYSTEM_KEY: key to make system calls on cores
* REGISTER_SYSTEM_KEY_1: key to make system calls on register
* REGISTER_ADMIN_KEY_1: key to make admin calls on register
* SERVICE_WEBSITE_IP_ADDRESS: if exists, please provide the IP address of the customer or service website - where to redirect from http://DOMAIN
* STATIC_WEB_IP_ADDRESS: hostname of static-web machine
* REG_MASTER_IP_ADDRESS: IP address of master register machine
* REG_MASTER_VPN_IP_ADDRESS: IP address of master register on a secure line between it and slave register (can be a private network)
* REG_SLAVE_IP_ADDRESS: IP address of slave register machine
* CORE_1_IP_ADDRESS (add more if needed): hostname or IP address of core machine
* CORE_HOSTING_1: name of hosting (or cluster), can be individual per core or contain many
* OVERRIDE_ME: single appearance values that need to be replaced with a strong key

#### optional variables

These fields will be available in https://reg.DOMAIN/service/infos

* PLATFORM_NAME
* SUPPORT_LINK
* TERMS_OF_USE_LINK