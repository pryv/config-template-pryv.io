const YAML = require('yamljs');
const fs = require('fs');
const _ = require('lodash');

let sourceConfig = YAML.load(__dirname + '/../config.yml');

// ##########################
// ####  Register & DNS  ####
// ##########################
let registerConfig = filterAuthorizedKeys(sourceConfig.register);
registerConfig.dns = {
  port: 5353,
  ip: sourceConfig.dns.listeningIp,
  name: 'reg.' + sourceConfig.domain,
  domain: sourceConfig.domain,
  domains: sourceConfig.extraDomains,
  staticDataInDomain: formatEntries(sourceConfig.dns.entries),
  domain_A: sourceConfig.dns.domain_A,
  nameserver: sourceConfig.dns.nameServers,
  mail: sourceConfig.dns.mail
};

registerConfig.net = {
  aaservers: filterCores(sourceConfig),
  aahostings: sourceConfig.hostings
};
registerConfig.redis = {
  host: 'redis',
  port: 6379
};
registerConfig.airbrake = sourceConfig.extra.airbrake.register;


function filterCores(source) { // cores
  let aaservers = {};
  source.cores.forEach((c) => {
    aaservers[c.hosting] = [
      {
        base_url: 'https://' + c.hostnameOrIp + '/',
        authorization: source.coreDefaults.systemKey
      }
    ]
  });
  return aaservers;
}

function filterAuthorizedKeys(source) { // authorizedKeys
  let registerConfig = _.cloneDeep(source);
  let output = {};
  registerConfig.systemKeys.forEach((k) => {
    output[k] = {
      roles: ['system']
    }
  });
  registerConfig.adminKeys.forEach((k) => {
    output[k] = {
      roles: ["admin"]
    }
  });
  delete registerConfig.systemKeys;
  delete registerConfig.adminKeys;
  registerConfig.auth =  {
    authorizedKeys: output
  };
  return registerConfig;
}

function formatEntries(entries) {
  let output = {};
  entries.forEach((e) => {
    if (e.type === 'alias') {
      output[e.name] = {
        alias: {
          name: e.value
        }
      };
    } else {
      output[e.name] = {
        ip: e.value
      }
    }
  });
  return output;
}

// ##########################
// #########  Core  #########
// ##########################
let coreConfig = sourceConfig.coreApi;
coreConfig.register = {
  secret: sourceConfig.register.systemKeys[0],
};
coreConfig.auth.adminAccessKey = sourceConfig.coreDefaults.systemKey;
coreConfig.eventTypes = sourceConfig.eventTypes;
coreConfig.services = {
  register: {
    url: sourceConfig.register.hostnameOrIP,
    key: sourceConfig.register.systemKeys[0],
  },
  email: sourceConfig.extra.coreApi.services.email,
};
coreConfig.logs.airbrake = sourceConfig.extra.airbrake.coreApi;
coreConfig.database = {
  authUser: coreConfig.mongo.username,
  authPassword: coreConfig.mongo.password,
  host: sourceConfig.mongo.host,
  port: sourceConfig.mongo.port,
  name: sourceConfig.mongo.databaseName
}
delete coreConfig.mongo;

// ##########################
// #######  Preview  ########
// ##########################
let previewConfig = sourceConfig.preview;
previewConfig.database = {
  authUser: previewConfig.mongo.username,
  authPassword: previewConfig.mongo.password,
  host: sourceConfig.mongo.host,
  port: sourceConfig.mongo.port,
  name: sourceConfig.mongo.databaseName
};
previewConfig.logs.airbrake = sourceConfig.extra.airbrake.preview;

delete previewConfig.mongo;

// ##########################
// ######  Static-web  ######
// ##########################
let swwwConfig = sourceConfig.swww;


// ##########################
// #####  Adjustments  ######
// ##########################

// Core

//delete coreConfig.http.noSSL;
coreConfig.database.host = 'mongodb';
// delete coreConfig.nightlyScriptCronTime;
// delete coreConfig.env;
coreConfig.eventFiles = {
  attachmentsDirPath: '/app/data/attachments',
  previewsDirPath: '/app/data/previews'
};
coreConfig.logs.file.path = '/app/log/core.log';
coreConfig.logs.airbrake.projectId = '95887';
coreConfig.eventTypes.sourceURL = 'https://api.pryv.com/event-types/flat.json'; // apply httpS
// delete coreConfig.auth.browserIdAudience;
coreConfig.http.ip = '0.0.0.0';
delete coreConfig.database.authUser;
delete coreConfig.database.authPassword;

// preview

previewConfig.eventFiles = {
  attachmentsDirPath: '/app/data/attachments',
  previewsDirPath: '/app/data/previews'
};
previewConfig.logs.airbrake.projectId = '95888';
previewConfig.http.ip = '0.0.0.0';
previewConfig.http.port = 9000;
previewConfig.database.host = 'mongodb';
delete previewConfig.database.authUser;
delete previewConfig.database.authPassword;

// Register

delete registerConfig.server.ip;

// Static-web

delete swwwConfig.http.ip;

writeOutput(__dirname + '/../');

function writeOutput(folder) {
  fs.writeFileSync(folder + 'reg-master/register/conf/register.json', JSON.stringify(registerConfig, null, 2));
  fs.writeFileSync(folder + 'reg-master/dns/conf/dns.json', JSON.stringify(registerConfig, null, 2));
  fs.writeFileSync(folder + 'reg-slave/register/conf/register.json', JSON.stringify(registerConfig, null, 2));
  fs.writeFileSync(folder + 'reg-slave/dns/conf/dns.json', JSON.stringify(registerConfig, null, 2));
  fs.writeFileSync(folder + 'core/core/conf/core.json', JSON.stringify(coreConfig, null, 2));
  fs.writeFileSync(folder + 'core/preview/conf/preview.json', JSON.stringify(previewConfig, null, 2));
  fs.writeFileSync(folder + 'static/static/conf/static.json', JSON.stringify(swwwConfig, null, 2));
}
