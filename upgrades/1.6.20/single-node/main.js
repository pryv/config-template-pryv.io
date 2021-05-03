const _ = require('lodash');

function upgrade (oldPlatform, newPlatformTemplate) {
  const oldMfa = platform.vars.MFA_SETTINGS.settings.MFA_SMS_API_SETTINGS.value;

  newPlatformTemplate.vars.MFA_SETTINGS.settings.MFA_ENDPOINTS.value = _.merge(
    newPlatformTemplate.vars.MFA_SETTINGS.settings.MFA_ENDPOINTS.value,
    {
      challenge: {
        url: oldMfa.endpoints.challenge,
        headers: {
          authorization: oldMfa.auth,
        },
      },
      verify: {
        url: oldMfa.endpoints.verify,
        headers: {
          authorization: oldMfa.auth,
        },
      },
    }
  );
}


