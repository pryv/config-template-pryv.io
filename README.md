# Pryv IO template configuration files

Please use this template as basis for future customer deployments and keep this up to date.

## Usage

1. Create new empty repository on GitHub named `config-DOMAIN`
2. Clone this repository: `git clone --bare git@github.com:pryv/config-template-pryv.io.git`
3. Mirror-push to the new repository: `cd config-template-pryv.io.git`, `git push --mirror git@github.com:pryv/config-DOMAIN.git`
4. Remove the temporary local repository you created in step 2: `cd ..`, `rm -rf config-template-pryv.io.git`
5. clone the new repository to work on it: `git clone git@github.com:pryv/config-DOMAIN.git`

You will find instructions regarding variables and other settings in the directories [pryv.io/cluster](pryv.io/cluster/) and [pryv.io/single-node](pryv.io/single-node/).

### Update clone from template

In the clone repository, add this template repository as a secondary remote: `git remote add template git@github.com:pryv/config-template-pryv.io.git`

Then each time, you wish to apply an update, run:
1. `git fetch template master`
2. `git merge template/master`
3. resolve conflicts
4. use update

### Update instructions to customers

When sending a new release to customers, please include these instructions:

1. Backup your configuration to allow rolling back.
2. Replace the configuration files for "docker-compose" by the new files in this release. 
3. Take your installation down ('docker-compose -f FILE down') and then recreate it from the new binaries: 'docker-compose -f FILE up -d'. This makes sure nothing lingers in docker. 
4. Verify the new release. 

### Versions

- **1.3**: v1.3 has been merged into master

- **v1.2**: v1.2 available on branch [release-1.2](https://github.com/pryv/config-template-pryv.io/tree/release-1.2)
