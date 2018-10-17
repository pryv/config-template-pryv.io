# Pryv IO template configuration files

Please use this template as basis for future customer deployments and keep this up to date.

## Usage

1. Create new empty repository on GitHub named `config-DOMAIN`
2. Clone this repository: `git clone --bare git@github.com:pryv/config-template-pryv.io.git`
3. Mirror-push to the new repository: `cd config-template-pryv.io.git`, `git push --mirror git@github.com:pryv/config-DOMAIN.git`
4. Remove the temporary local repository you created in step 2: `cd ..`, `rm -rf config-template-pryv.io.git`
5. clone the new repository to work on it: `git clone git@github.com:pryv/config-DOMAIN.git`

You will find instructions regarding variables and other settings in the directories [pryv.io/cluster](pryv.io/cluster/) and [pryv.io/single-node](pryv.io/single&#32;node/).

### Versions

- **1.3**: v1.3 has been merged into master

- **v1.2**: v1.2 available on branch [release-1.2](https://github.com/pryv/config-template-pryv.io/tree/release-1.2)
