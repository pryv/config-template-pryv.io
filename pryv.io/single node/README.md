# Pryv.io configuration template

In the `pryv.io/` folder, you will find the template configuration files for a pryv.io single node installation.

## Usage

1. Replace the [platform-specific variables](#variables) in the `pryv/**/conf/*.{json|conf}` files. Use `Replace in path` or equivalent in a IDE.
2. If needed, update docker image versions in `{core,reg,static}.yml`.
3. Generate tarballs from config files using `./build ${DOMAIN}`.
4. Follow the instructions in `INSTALL.md` to install and run the software on the dedicated machines.

### Local Usage

In [pryv/nginx/conf/nginx.conf], uncomment the following lines:  

```
# ssl_certificate      /app/conf/secret/rec.la-bundle.crt;
# ssl_certificate_key  /app/conf/secret/rec.la-key.pem;
```

and comment out the following ones:

```
ssl_certificate      /app/conf/secret/DOMAIN-bundle.crt;
ssl_certificate_key  /app/conf/secret/DOMAIN-key.pem;
```

Then set the DOMAIN as rec.la in the variables below. You can leave the keys as-is, since the components will communicate locally.

### Variables

These values need to be replaced in the configuration. If possible, obtain these from the customer to do the replace operation.

* DOMAIN: the domain of the platform (eg.: pryv.me)
* CORE_ADMIN_KEY: key to make admin calls on cores
* REGISTER_SYSTEM_KEY_1: key to make system calls on register
* REGISTER_ADMIN_KEY_1: key to make admin calls on register
* SERVICE_WEBSITE_IP_ADDRESS: if exists, please provide the IP address of the customer or service website
* MACHINE_IP_ADDRESS: IP address of machine running pryv.io
* OVERRIDE_ME: single appearance values that need to be replaced with a strong key
