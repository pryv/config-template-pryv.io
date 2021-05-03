const fs = require('fs');
const YAML = require('yaml');

function fromData (data) {
  return YAML.parse(data);
}

function fromPath (path) {
  const data = fs.readFileSync(path, { encoding: 'utf-8' });
  return fromData(data);
}



module.exports = {
  fromPath,
  fromData,
};