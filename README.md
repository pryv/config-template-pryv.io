# Pryv.io configuration template

In the `pryv.io/` folder, you will find the template configuration files for a pryv.io installation.
 
 
## Usage

*Prerequisites*: Node v6+, Yarn v1+

* Copy this repository content in new repository `config-DOMAIN`
* Replace the platform-specific variables in the `pryv.io/config.yml` file.
* run `yarn install` to download dependencies.
* run `yarn fromYaml` to generate v1.2 compatible configuration files from the `pryv.io/config.yml` source.
* replace the remaining (mostly NGINX) `DOMAIN` to your domain.
* in `pryv.io/static/nginx/conf/site.conf`, change the proxying for route `/access/` to `https://pryv.github.io/app-web-auth2/DOMAIN/`.
* On the [app-web-auth2 repository gh-pages branch](https://github.com/pryv/app-web-auth2/), create a symlink to the latest version named `DOMAIN`.
* If needed, update docker image versions in `pryv.io/{core,reg,static}.yml`.
* Generate tarballs from config files using `./scripts/build ${DOMAIN}`.
* Follow the instructions in `pryv.io/INSTALL.md` to install and run the software on the dedicated machines.

### Variables

These values need to be replaced in the configuration. If possible, obtain these from the customer to do the replace operation.

* DOMAIN: the domain of the platform (eg.: pryv.me)
* CORE_SYSTEM_KEY: key to make system calls on cores
* REGISTER_SYSTEM_KEY_1: key to make system calls on register
* REGISTER_ADMIN_KEY_1: key to make admin calls on register
* SERVICE_WEBSITE_IP_ADDRESS: if exists, please provide the IP address of the customer or service website
* STATIC_WEB_HOSTNAME: hostname of static-web machine
* REG_MASTER_HOSTNAME: hostname of master register machine
* REG_MASTER_IP_ADDRESS: IP address of master register machine
* REG_SLAVE_HOSTNAME: hostname of slave register machine
* REG_SLAVE_IP_ADDRESS: IP address of slave register machine
* CORE_1_HOSTNAME_OR_IP (add more if needed): hostname or IP address of core machine
* CORE_HOSTING_1: name of hosting (or cluster), can be individual per core or contain many
* OVERRIDE_ME: single appearance values that need to be replaced with a strong key
