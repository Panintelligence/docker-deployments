import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	site: 'https://panintelligence.github.io',
	base: '/docker-deployments',
	integrations: [
		starlight({
			title: 'Panintelligence Container Deployments',
			social: {
				github: 'https://github.com/panintelligence',
			},
			sidebar: [
				{
					label: 'Guides',
					items: [
						// Each item here is one entry in the navigation menu.
						{ label: 'Basic Example', link: '/guides/base/' },
					],
				}
			],
		}),
	],
});
