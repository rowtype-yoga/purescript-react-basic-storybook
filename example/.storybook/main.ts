import { indexer } from './purescript-indexer'

export default {
  staticDirs: ['../public'],
  addons: ["@storybook/addon-essentials", "@storybook/addon-interactions" ],
  stories: ["../output/Story.*/index.js", "../stories/docs/**/*.mdx"],
  framework: "@storybook/react-webpack5",
  storyIndexers: [{ test: /..\/output\/.*/, indexer }],
  disableTelemetry: true,
}
