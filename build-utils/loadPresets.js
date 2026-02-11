const { merge } = require('webpack-merge');

const loadPresets = env => {
  const presets = env.presets || [];

  const mergedPresets = String(presets)
    .split(',')
    .map(preset => preset.trim())
    .filter(Boolean);

  const mergedconfigs = mergedPresets.map(
    presetName => require(`./presets/webpack.${presetName}`)(env)
  );

  return merge({}, ...mergedconfigs);
};

module.exports = loadPresets;
