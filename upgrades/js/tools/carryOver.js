
function carryOver(oldPlatform, newTemplate) {
  for (const mainSetting of Object.keys(oldPlatform.vars)) {
    if (newTemplate.vars[mainSetting]) {
      for (const subSetting of Object.keys(oldPlatform.vars[mainSetting].settings)) {
        if (newTemplate.vars[mainSetting].settings[subSetting]) {
          newTemplate.vars[mainSetting].settings[subSetting].value = oldPlatform.vars[mainSetting].settings[subSetting].value;
        }
      }
    }
  }
  return newTemplate;
}

module.exports = {
  carryOver,
};