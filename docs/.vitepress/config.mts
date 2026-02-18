import { withMermaid } from 'vitepress-plugin-mermaid'
import apiSidebar from '../api/_sidebar.json'

export default withMermaid({
  title: 'STRINGIFOR Documentation',
  base: '/STRINGIFOR/',
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
      {
        text: 'Guide',
        items: [
          { text: 'About',              link: '/guide/' },
          { text: 'Features',           link: '/guide/features' },
          { text: 'Comparison',         link: '/guide/comparison' },
          { text: 'Installation',       link: '/guide/installation' },
          { text: 'Basic I/O',          link: '/guide/basic-io' },
          { text: 'String Manipulation',link: '/guide/string-manipulation' },
          { text: 'Numbers',            link: '/guide/numbers' },
          { text: 'Advanced Usage',     link: '/guide/advanced' },
          { text: 'API Reference',      link: '/guide/api-reference' },
          { text: 'Contributing',       link: '/guide/contributing' },
          { text: 'Changelog',          link: '/guide/changelog' },
        ],
      },
      { text: 'API', link: '/api/' },
    ],
    sidebar: {
      '/guide/': [
        {
          text: 'Introduction',
          items: [
            { text: 'About',      link: '/guide/' },
            { text: 'Features',   link: '/guide/features' },
            { text: 'Comparison', link: '/guide/comparison' },
          ],
        },
        {
          text: 'Getting Started',
          items: [
            { text: 'Installation',        link: '/guide/installation' },
            { text: 'Basic I/O',           link: '/guide/basic-io' },
            { text: 'String Manipulation', link: '/guide/string-manipulation' },
            { text: 'Numbers',             link: '/guide/numbers' },
            { text: 'Advanced Usage',      link: '/guide/advanced' },
            { text: 'API Reference',       link: '/guide/api-reference' },
          ],
        },
        {
          text: 'Project',
          items: [
            { text: 'Contributing', link: '/guide/contributing' },
            { text: 'Changelog',    link: '/guide/changelog' },
          ],
        },
      ],
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
