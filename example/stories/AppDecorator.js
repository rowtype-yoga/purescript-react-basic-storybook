import { PrismLight as SyntaxHighlighter } from 'react-syntax-highlighter';
import purescript from 'react-syntax-highlighter/dist/esm/languages/prism/purescript';

export const registerPS = () => SyntaxHighlighter.registerLanguage("purescript", purescript)
