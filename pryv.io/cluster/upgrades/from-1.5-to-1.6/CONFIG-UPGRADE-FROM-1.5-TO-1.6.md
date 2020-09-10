
# Config upgrade from version 1.5.x to 1.6.0

This guide describes the config parameters that you should put in place when upgrading your Pryv.io platform from 1.5 to 1.6 version. If you have an older version, please first upgrade to the 1.5 version.

## Platform variables

You must edit `config-leader/conf/platform.yml` file with the values provided below.  

#### New config values
1. Now user registration could be customized by appending `CUSTOM_SYSTEM_STREAMS:account` parameter list.
```
Default CUSTOM_SYSTEM_STREAMS value is email field because 
it could be set as mandatory or not during the registration

CUSTOM_SYSTEM_STREAMS={
    "account": [
      {
       "id": "email",
       "type": "email/string",
       "isIndexed": true,
       "isUnique": true,
       "isShown": true,
       "isEditable": true,
       "name": "Email",
       "isRequiredInValidation": true
      }
    ]
}
```

## Custom user registration

You could add additional fields that would be saved to userAccount data. For that you would need 
to append data to CUSTOM_SYSTEM_STREAMS:account list.
```
Example for custom field:

{
  "id": "insuranceNumber", 
  "type": "insurancenumber/string",
  "isIndexed": false,
  "isUnique": false,
  "isShown": true,
  "isEditable": false,
  "name": "Insurance number",
  "isRequiredInValidation": false,
  "regexValidation": "^[0-9]*$"
}
```

*  id - streamId that will be saved to the event
    *  string
    *  required

*  type - type that will be saved for the event
    *  string
    *  required

*  isIndexed - if true, the value will be saved not only on core but also on service-register
    *  boolean
    *  optional, default false

*  isUnique - if true, the value will be validated to be unique globally in the system
    *  boolean
    *  optional, default false

*  isShown - if true, the value will be showed with events and account details
    *  boolean
    *  optional, default false

*  isEditable - if true, the value will be allowed to edit
    *  boolean
    *  optional, default false
    
*  name - the name of the stream
    *  string
    *  optional, default is the same as id

*  isRequiredInValidation - if true, the value will be validated to exist in the registration fields
    *  boolean
    *  optional, default false

*  regexValidation - if present, will validate field with a given regex rule
    *  string
    *  optional, default null
    
```
So full config with email and insurance number would look like this:

CUSTOM_SYSTEM_STREAMS={
    "account": [
    {
      "id": "email",
      "type": "email/string",
      "isIndexed": true,
      "isUnique": true,
      "isShown": true,
      "isEditable": true,
      "name": "Email",
      "isRequiredInValidation": true
    },
    {
      "id": "insuranceNumber", 
      "type": "insurancenumber/string",
      "isIndexed": false,
      "isUnique": false,
      "isShown": true,
      "isEditable": false,
      "name": "Insurance number",
      "isRequiredInValidation": false,
      "regexValidation": "^[0-9]*$"
    }
    ]
}
```

## Main config upgrade sequence 

The guide how to update the Pryv.io config is the same as in UPDATE.md
For the consistency, the content of UPDATE.md is listed below: 

1. Backup all your files in all servers.
2. Backup platform parameters and keys:

  - Leader:
    - `${PRYV_CONF_ROOT}/config-leader/conf/platform.yml`
    - `${PRYV_CONF_ROOT}/config-leader/conf/config-leader.json`
  - Followers:
    - `${PRYV_CONF_ROOT}/config-follower/conf/config-follower.json`

3. Untar new template in PRYV_CONF_ROOT: `tar xzfv ${ROLE}.tgz -C ${PRYV_CONF_ROOT} --strip-components=1 --overwrite`
4. Add new values in your `platform.yml`, `config-leader.json` & `config-follower.json` files. Use `diff` to find new values.
5. Replace the template platform config files with your backed up ones
6. Reboot services, starting with reg-master

    6.1 leader: `./restart-config-leader`
    
    6.2 follower: `./restart-config-follower`
    
    6.3 If you are using `app-web-auth3` and have a large users base, you can use
  `pryvsa-docker-release.bintray.io/pryv/register:1.6.0-while-migrating` docker image instread of `pryvsa-docker-release.bintray.io/pryv/register:1.6.0`
  while migrating. It will force the `app-web-auth3` to use the old registration API endpoint until
  you will deploy the new Pryv.io versions to the all cores.
    
    6.4 Pryv.io: `./restart-pryv`
