import { promises } from "fs"
import { loadCsf, CsfFile, CsfOptions } from '@storybook/csf-tools';

const adjustSourceForStorybook = (source: string): string => {
  // regex for var $$default = unsafeCoerce({ ... })
  // we need to remove the unsafeCoerce part so that the parser can read
  // the info about the story
  const defaultVariableRecordRegex = /^var \$\$default =[^\{]+\{((?:.*\n)+?)(^\}\);)/gm;
  // $ has a special meaning so to produce two dollar signs we need $$$$
  const replacement = "var $$$$default = { $1 };";
  return source.replace(defaultVariableRecordRegex, replacement);
}

export const indexer = async (fileName: string, opts: CsfOptions): Promise<CsfFile> => {
  const fileContent:string = await promises.readFile(fileName, 'utf-8');
  const fixedFileContent:string = adjustSourceForStorybook(fileContent);
  return loadCsf(fixedFileContent, { ...opts, fileName }).parse();
}
