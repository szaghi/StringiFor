import { withMermaid } from 'vitepress-plugin-mermaid'
import apiSidebar from '../api/_sidebar.json'

// one sidebar for every page but the API, in reading order: the "previous" and "next" links at the bottom of a page
// follow it, so the documentation reads from the first page to the last
const docs = [
  {
    text: 'Start here',
    items: [
      { text: 'Introduction', link: '/guide/' },
      { text: 'Installation', link: '/guide/installation' },
    ],
  },
  {
    text: 'Tutorial',
    items: [
      { text: 'Overview',                     link: '/manual/' },
      { text: '1. A first string',            link: '/manual/tutorial/01-first-string' },
      { text: '2. Cleaning and transforming', link: '/manual/tutorial/02-cleaning' },
      { text: '3. Splitting and joining',     link: '/manual/tutorial/03-splitting' },
      { text: '4. Numbers',                   link: '/manual/tutorial/04-numbers' },
      { text: '5. Files and paths',           link: '/manual/tutorial/05-files' },
      { text: '6. A polished report',         link: '/manual/tutorial/06-report' },
    ],
  },
  {
    text: 'Recipes',
    items: [
      { text: 'Cookbook', link: '/manual/cookbook' },
    ],
  },
  {
    text: 'Reference',
    items: [
      { text: 'Feature map',         link: '/guide/features' },
      { text: 'Strings and I/O',     link: '/guide/basic-io' },
      { text: 'String Manipulation', link: '/guide/string-manipulation' },
      { text: 'Numbers',             link: '/guide/numbers' },
      { text: 'Files and Paths',     link: '/guide/advanced' },
      { text: 'Methods Summary',     link: '/guide/api-reference' },
    ],
  },
  {
    text: 'Project',
    items: [
      { text: 'Comparison',   link: '/guide/comparison' },
      { text: 'Changelog',    link: '/guide/changelog' },
      { text: 'Contributing', link: '/guide/contributing' },
    ],
  },
]

export default withMermaid({
  title: 'StringiFor Documentation',
  base: '/StringiFor/',
  markdown: {
    math: true,
    languages: ['fortran-free-form', 'fortran-fixed-form'],
    languageAlias: {
      'fortran': 'fortran-free-form',
      'f90': 'fortran-free-form',
      'f95': 'fortran-free-form',
      'f03': 'fortran-free-form',
      'f08': 'fortran-free-form',
      'f77': 'fortran-fixed-form',
    },
  },
  themeConfig: {
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Start here', link: '/guide/', activeMatch: '^/guide/(index|installation)' },
      { text: 'Tutorial', link: '/manual/tutorial/01-first-string', activeMatch: '^/manual/(index|tutorial/)' },
      { text: 'Cookbook', link: '/manual/cookbook', activeMatch: '^/manual/cookbook' },
      {
        text: 'Reference',
        link: '/guide/features',
        activeMatch: '^/guide/(features|basic-io|string-manipulation|numbers|advanced|api-reference)',
      },
      { text: 'API', link: '/api/' },
      {
        text: 'Project',
        items: [
          { text: 'Comparison',   link: '/guide/comparison' },
          { text: 'Changelog',    link: '/guide/changelog' },
          { text: 'Contributing', link: '/guide/contributing' },
        ],
      },
    ],
    sidebar: {
      '/guide/': docs,
      '/manual/': docs,
      '/api/': [
        {
          text: 'API Reference',
          items: [
            { text: 'Overview', link: '/api/' },
          ],
        },
        ...apiSidebar,
      ],
    },
    search: {
      provider: 'local',
    },
  },
  mermaid: {},
})
