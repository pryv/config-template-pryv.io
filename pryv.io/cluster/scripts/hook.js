#!/usr/bin/node
/* npm install yamljs */
/* npm install request */
/* apt-get install certbot */
/* apt-get install dnsutils */
const yaml = require('yamljs');
const fs = require('fs');
const { execSync } = require('child_process');
const request = require('request');
const settings = require('/app/scripts/settings.json')
main();
async function main() {
    console.log('Start letsencrypt');
    const acme = process.env.CERTBOT_VALIDATION.toString();
    let modifiedConfig = yaml.load(settings.platformPath);
    modifiedConfig.vars.DNS_SETTINGS.settings.DNS_CUSTOM_ENTRIES.value['_acme-challenge'].description = acme;
    console.log('Write the acme-challenge in the DNS');
    fs.writeFileSync(settings.platformPath, yaml.stringify(modifiedConfig, 6, 3));
    const token = (await requestToken()).token;
    await sendAcmeToDNS(token);
    var dig_txt = '';
    const startTime = new Date();
    console.log('Check if the DNS answers with the acme-challenge')
    let counter = 0;
    while (dig_txt !== acme && counter > 3) {
        dig_txt = execSync('dig @' + settings.privateAddressDns + ' TXT +noall +answer +short _acme-challenge.' + settings.domain).toString().replace(/"/g, '').trim();
        if(dig_txt == acme){
            counter += 1;
        } else{
            counter = 0;
        }
        let endTime = new Date();
        if (endTime - startTime > settings.timeout) {
            throw new Error('Timeout');
        }
    }
    console.log("done")
}

async function sendAcmeToDNS(token) {
    const options = {
        url: settings.baseUrl + '/admin/notify',
        headers: {
            "Authorization": token
        },
        json: true,
        body: {
            services: settings.servicesToRestart
        }
    };
    return new Promise((resolve, reject) => {
        request.post(options, (error, res, body) => {
            if (!error && res.statusCode == 200) {
                resolve(body);
            }
            else {
                reject(error);
            }
        });
    });
}

async function requestToken() {
    const options = {
        url: settings.baseUrl + '/auth/login',
        json: true,
        body: {
            username: settings.username,
            password: settings.password
        }
    };
    return new Promise((resolve, reject) => {
        request.post(options, (error, res, body) => {
            if (!error && res.statusCode == 200) {
                resolve(body);
            }
            else {
                reject(error);
            }
        });
    });
}