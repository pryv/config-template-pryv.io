# Pryv.io configuration template

In the current folder, you will find the template configuration files for a Pryv.io singlenode installation.

## Usage

Run `./scripts/build ${CUSTOMER}` to generate configuration tarballs in `tarballs/`.

Distribute them to customer, who will follow the instructions in `INSTALL.md` to install and run the software.

## Adaptations

For a local usage, uncomment the following lines in [config-leader/data/singlenode/nginx/conf/nginx.conf]:  

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