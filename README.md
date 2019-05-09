# Pryv.li - staging environment

This contains the configuration files of Pryv's staging environment.  

Please refer to the Apps dedicated README files for installation instructions.

* [pryv.io](pryv.io/)

### Update clone from template

In the clone repository, add this template repository as a secondary remote: `git remote add template git@github.com:pryv/config-template-pryv.io.git`

Then each time, you wish to apply an update, run:
1. `git fetch template master`
2. `git merge template/master`
3. resolve conflicts
4. use update

