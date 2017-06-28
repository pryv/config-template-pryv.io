const registerConfig = require(__dirname + '/../v1.1-config/registration-server.config.json');
const coreConfig = require(__dirname + '/../v1.1-config/service-core-api.config.json');
const previewConfig = require(__dirname + '/../v1.1-config/service-core-preview.config.json');
const swwwConfig = require(__dirname + '/../v1.1-config/static-web.config.json');

const yamlOutput = __dirname + '/../pryv.io/config.yml';

const YAML = require('yamljs');
const fs = require('fs');
const _ = require('lodash');

const domain = registerConfig.dns.domain;

let config = {
  version: '1.0.0',
  domain: domain,
  extraDomains: registerConfig.dns.domains,
  redis: {
    password: registerConfig.redis.password,
  },
  coreDefaults: {
    systemKey: coreConfig.auth.adminAccessKey
  },
  dns: {
    listeningIp: registerConfig.dns.ip,
    listeningPort: registerConfig.dns.port,
    domainA: registerConfig.dns.domain_A,
    entries: filterDnsEntries(registerConfig.dns.staticDataInDomain),
    nameServers: registerConfig.dns.nameserver,
    server: {
      ssl: false,
      port: 9000
    }
  },
  cores: filterCores(registerConfig.net.aaservers,
    registerConfig.net.AAservers_domain),
  hostings: registerConfig.net.aahostings,
  mongo: {
    host: 'localhost',
    port: 27017,
    databaseName: coreConfig.database.name,
  },
  eventTypes: coreConfig.eventTypes,
  coreApi: {
    mongo: {
      username: coreConfig.database.authUser,
      password: coreConfig.database.authPassword,
    },
    eventFiles: coreConfig.eventFiles,
    http: coreConfig.http,
    auth: coreConfig.auth,
    logs: {
      console: coreConfig.logs.console,
      file: coreConfig.logs.file
    },
  },
  preview: {
    http: previewConfig.http,
    mongo: {
      username: previewConfig.database.authUser,
      password: previewConfig.database.authPassword,
    },
    eventFiles: previewConfig.eventFiles,
    logs: {
      console: previewConfig.logs.console,
      file: previewConfig.logs.file
    },
    auth: previewConfig.auth
  },
  swww: {
    http: swwwConfig.http,
    http2: swwwConfig.http2,
    browserBootstrap: swwwConfig.browserBootstrap,
    redirect: swwwConfig.redirect
  },
  register: {
    hostnameOrIP: 'https://reg.' + domain,
    systemKeys: filterKeysByContent(Object.keys(registerConfig.auth.authorizedKeys),
      registerConfig.auth.authorizedKeys,
      (o) => {
        return o.roles[0] === 'system'
      }),
    adminKeys: filterKeysByContent(Object.keys(registerConfig.auth.authorizedKeys),
      registerConfig.auth.authorizedKeys,
      (o) => {
        return o.roles[0] === 'admin'
      }),
    http: registerConfig.http, // WTF
    service: registerConfig.service, // WTF
    server: registerConfig.server, // WTF
    appList: registerConfig.appList // WTF
  },
  extra: {
    dns: {
      mail: registerConfig.dns.mail
    },
    coreApi: {
      services: {
        email: coreConfig.services.email
      }
    },
    airbrake: {
      coreApi: coreConfig.logs.airbrake,
      preview: previewConfig.logs.airbrake,
      register: registerConfig.airbrake,
    }
  },
};

function filterDataType(source) {
  let output = [];
  const keys = Object.keys(source);
  keys.forEach((k) => {
    output.push({

    })
  });
  return output;
}

function filterCores(source, secondayDomain) { // aaservers
  let output = [];
  const keys = Object.keys(source);
  keys.forEach((k) => {
    output.push({
      hostnameOrIp: source[k][0].base_name + '.'
      + secondayDomain,
      hosting: k
    })
  })
  return output;
}

function filterDnsEntries(source) { // dns.staticDataInDomain
  const keys = Object.keys(source);
  let output = [];
  keys.forEach((k) => {
    if (source[k].alias) {
      output.push({
        name: k,
        type: 'alias',
        value: source[k].alias[0].name
      });
    } else {
      output.push({
        name: k,
        type: 'ip',
        value: source[k].ip
      });
    }
  });
  return output;
}

function filterKeysByContent(keys, object, predicate) {
  let ret = [];
  keys.forEach((k) => {
    if (predicate(object[k])) {
      ret.push(k);
    }
  });
  return ret;
}

const yamlConfig = YAML.stringify(config, 10, 2);

console.log(yamlConfig); // for some reason '3' as 2nd argument gives the wanted output

fs.writeFileSync(yamlOutput, yamlConfig);



