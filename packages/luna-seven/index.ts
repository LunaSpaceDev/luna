import type { ConfigType } from '@plone/registry';

export default function install(config: ConfigType) {
  config.settings.fortytwo.voltoUrl = 'https://volto.lunaspace.dev';
  return config;
}
