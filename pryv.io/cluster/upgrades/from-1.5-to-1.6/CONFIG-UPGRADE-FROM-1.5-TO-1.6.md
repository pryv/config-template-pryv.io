
# Config upgrade from version 1.5 to 1.6.0

This guide describes the config parameters that you should put in place when upgrading your Pryv.io platform from 1.5 to 1.6 version. If you have an older version, please first upgrade to the 1.5 version.

## Platform variables

You must edit `config-leader/conf/platform.yml` file with the values provided below.  

#### New config values
1. Now the Platform API version exists as 'PRYV_IO_VERSION' parameter in platform.yml. It will be used to change the 
authentication interface (app-web-auth3). If it is not set or the version is set to lower than `1.6.0` version,
the old registration API endpoint will be used to register the user. 
2. Now user registration could be customized by appending `CUSTOM_SYSTEM_STREAMS:account` parameter list.
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