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

* 
