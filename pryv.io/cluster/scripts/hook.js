#!/usr/bin/node
const fs = require('fs');
const { execSync } = require('child_process');
const request = require('request');
const settings = require('/app/scripts/settings.json');

main();
async function main() {
    console.log('Start letsencrypt');
    const acme = process.env.CERTBOT_VALIDATION.toString();
    let modifiedConfig = fs.readFileSync(settings.platformPath).toString();
    let backup = fs.readFileSync(settings.platformPath).toString();
    const regex = /\${ACME}/gi;
    modifiedConfig = modifiedConfig.replace(regex, acme);
    console.log('Write the acme-challenge in the DNS');
    fs.writeFileSync(settings.platformPath, modifiedConfig);
    const token = (await requestToken()).token;
    await sendAcmeToDNS(token);
    var dig_txt = '';
    const startTime = new Date();
    console.log('Check if the DNS answers with the acme-challenge');
    let counter = 0;
    while (dig_txt !== acme && counter < 3) {
        dig_txt = execSync('dig @' + settings.privateAddressDns + ' TXT +noall +answer +short _acme-challenge.' + settings.domain).toString().replace(/"/g, '').trim();
        if (dig_txt == acme) {
            counter += 1;
        } else {
            counter = 0;
        }
        let endTime = new Date();
        if (endTime - startTime > settings.timeout) {
            fs.writeFileSync(settings.platformPath, backup);
            throw new Error('Timeout');
        }
    }
    fs.writeFileSync(settings.platformPath, backup);
    console.log("done");
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