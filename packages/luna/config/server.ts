import type { ConfigType } from '@plone/registry';
import PloneClient from '@plone/client';

export default function installServer(config: ConfigType) {
  // Re-initialize the PloneClient with empty apiSuffix for Nick CMS
  const cli = PloneClient.initialize({
    apiPath: config.settings.apiPath,
    apiSuffix: '', // Nick CMS doesn't use ++api++ prefix
  });

  // Re-register the client utility
  config.registerUtility({
    name: 'ploneClient',
    type: 'client',
    method: () => cli,
  });

  return config;
}
