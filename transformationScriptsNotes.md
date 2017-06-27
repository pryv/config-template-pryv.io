## Adjustments

* Database credentials: drop or import? -> importing seems the easiest. Need to check if they are still used.  
* Ports change, but they match the docker-compose port settings.  
* `eventFiles` & `logs/file/path` paths are different and will be for docker & classical deployments.
* logs.console/file have different values on active, level & colorize
* register.server.ip (=127.0.0.1) is deleted as it is now in docker network
* swww.http.ip (=127.0.0.1) is deleted as it is now in docker network

### proposed:
* http.noSSL parameter is present but unused!!! -> to ignore
* in core: nightlyScriptCronTime doesn't appear as it was matching the default value assigned in config.js. -> Remove it from config
* env: is missing, but apiServer & preview are in production by default. -> Remove it from config
* auth.browserIdAudience is not found in core -> to delete?

## to discuss
* in dns.json: 
	* store machines ip adresses?  
	* store cores ip adresses, giving them either a name depending on their position in the cores array or some other pattern.
* in DNS source code (v1.1 & v1.2): domainA is not found
* airbrake uses *active* in coreApi, preview, but *disable* in register

## Questions:
* What is http2 in static-web?


## preliminary notes

### v1.2static.json
http/http2 has no ip
http2 has no port
browserBootstrap.field.browser-source: has cloudfront link, but sw.domain/browser in v1.2

### v1.2preview.json
env.production is missing
http.ip is 0.0.0.0 instead of localhost -> makes sense as we are now dockerized so on different hosts network-wise
http.port is 9000 instead of 10000 - why not
database has no credentials

has different default paths for `eventFiles` & `logs/file/path`

### v1.2dns.json
airbrake: {disable:true} is missing

### v1.2register.json
airbrake: {disable:true} is missing
server.ip is now there, but shouldn't be?

### v1.2core.json
http.noSSL parameter is present but unused!!!

there was more fields in auth.trusterApps in v1.1

airbrake: {disable:true} is missing

has the following which no one has:  
- "nightlyScriptCronTime": "00 15 2 * * *" OK   
- "env": "production"

has different default paths for `eventFiles` & `logs/file/path`



