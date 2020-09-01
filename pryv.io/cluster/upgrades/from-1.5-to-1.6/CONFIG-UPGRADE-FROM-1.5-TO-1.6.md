
# Config upgrade from 1.5 to 1.6

This guide describes the config parameters that you should put in place when upgrading your Pryv.io platform from 1.5 to 1.6 version. If you have an older version, please first upgrade to the 1.5 version.

## Platform variables

You must edit `config-leader/conf/platform.yml` file with the values provided below.  

#### New config values
1. (No action needed for cluster mode) By default now Pryv comes as a single node and for cluster mode to work, SINGLE_NODE:IS_ACTIVE should be set to false as in the SINGLE_NODE.
2. Now user registration could be customized by appending CUSTOM_SYSTEM_STREAMS:account parameter list.
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

You could add additional fields that would be saved to userAccount data. for that you would need 
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

*  insuranceNumber - streamId that will be saved to the event
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