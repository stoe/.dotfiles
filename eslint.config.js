import globals from 'globals'
import markdown from '@eslint/markdown'
import prettierConfig from 'eslint-config-prettier'
import prettierPluginRecommended from 'eslint-plugin-prettier/recommended'

export default [
  {ignores: ['.vscode/extensions/']},
  prettierConfig,
  prettierPluginRecommended,
  {
    files: ['*.js'],
    ignores: ['build/', 'cache/', 'coverage/', 'dist/', 'node_modules/'],
    languageOptions: {
      globals: {
        ...globals.node,
      },
      parserOptions: {ecmaVersion: 'latest', sourceType: 'module'},
    },
    rules: {
      'prettier/prettier': 'error',
    },
  },
  ...markdown.configs.recommended,
  ...markdown.configs.processor,
]
