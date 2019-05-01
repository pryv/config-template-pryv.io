# Pryv.li - staging environment

This contains the configuration files of Pryv's staging environment.  

Please refer to the Apps dedicated README files for installation instructions.

* [pryv.io](pryv.io/)
* [bluebutton](bluebutton/)

### Update clone from template

In the clone repository, add this template repository as a secondary remote: `git remote add template git@github.com:pryv/config-template-pryv.io.git`

Then each time, you wish to apply an update, run:
1. `git fetch template master`
2. `git merge template/master`
3. resolve conflicts
4. use update

<<<<<<< HEAD
=======
### Update instructions to customers

When sending a new release to customers, please include these instructions:

1. Backup your configuration to allow rolling back.
2. Replace the configuration files for "docker-compose" by the new files in this release. 
3. Take your installation down ('docker-compose -f FILE down') and then recreate it from the new binaries: 'docker-compose -f FILE up -d'. This makes sure nothing lingers in docker. 
4. Verify the new release. 

### Versions

- **1.4**: v1.4 is currently tested, available on [its own branch](https://github.com/pryv/config-template-pryv.io/tree/release-1.4)

- **1.3**: v1.3 has been merged into master

- **v1.2**: v1.2 available on branch [release-1.2](https://github.com/pryv/config-template-pryv.io/tree/release-1.2)
>>>>>>> template/release-1.4
