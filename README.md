# Pryv.io template configuration files

Please use this template as basis for future customer deployments and keep this up to date.


## Publishing a new version

See the [steps to publish a new release](https://github.com/pryv/intranet/blob/master/Engineering/Codebase/Publishing%20a%20new%20release.md#in-config-template) on the intranet.


## Customer usage

Reference: [Pryv.io setup guide](https://api.pryv.com/customer-resources/pryv.io-setup/#obtain-the-license-key-credentials-and-configuration-files)

1. Send a link of the latest version from [api.pryv.com/config-template-pryv.io/](https://api.pryv.com/config-template-pryv.io/)
2. Send license keys
3. [Generate and send a GCP repository key](https://github.com/pryv/intranet/blob/master/Engineering/Infrastructure/Docker%20private%20registry.md)
4. Save this key to 1Password, under "Google cloud platform docker registry"


## Internal usage (as git repository clone)

These instructions explain how to setup a clone of this repository as is done for pryv.me, pryv.li & rec.la:
- https://github.com/pryv/config-pryv.me
- https://github.com/pryv/config-pryv.li
- https://github.com/pryv/config-rec.la

### Setup repository

1. Create new empty repository on GitHub named `config-DOMAIN`
2. Clone this repository: `git clone --bare git@github.com:pryv/config-template-pryv.io.git`
3. Mirror-push to the new repository: `cd config-template-pryv.io.git`, `git push --mirror git@github.com:pryv/config-DOMAIN.git`
4. Remove the temporary local repository you created in step 2: `cd ..`, `rm -rf config-template-pryv.io.git`
5. clone the new repository to work on it: `git clone git@github.com:pryv/config-DOMAIN.git`

### Update clone from template

In the clone repository, add this template repository as a secondary remote: `git remote add template git@github.com:pryv/config-template-pryv.io.git`

Then each time, you wish to apply an update, run:

1. `git fetch template`
2. `git merge template/master`
3. resolve conflicts (mostly remove extra deployment type)
4. use update
 
