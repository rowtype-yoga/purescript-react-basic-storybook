import { indexer } from './purescript-indexer.mjs';
export default {
  stories: ["../output/Story.*/index.js"],
  framework: "@storybook/react-webpack5",
  storyIndexers: [{ test: /.*/, indexer }],
};
