import { promises } from "fs"
import { loadCsf } from '@storybook/csf-tools';

// Helper
const mapWithKeys = (obj, fn) => Object.fromEntries(Object.entries(obj).map(([k, v], i) => fn(k, v, i)));

const capitalise = str => {
  if (str.length === 0) return str;
  return str.charAt(0).toUpperCase() + str.slice(1);
};

// Actual indexer
export const indexer = async (fileName, opts) => {
  const fileContent = await promises.readFile(fileName, 'utf-8')
  const parsed = loadCsf(fileContent, opts).parse()
  parsed._stories = mapWithKeys(parsed._stories,
    (k, v) => [capitalise(k), { ...v, name: capitalise(v.name) }]
  );
  return parsed;
}
