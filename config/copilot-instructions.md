For any code use the following configuration files (if they are present):

- `<root>/.editorconfig`

For all JavaScript/TypeScript/Node.js code, ensure the formatting adheres to the rules specified in the following files (if they are present):

- `<root>/eslint.config.js`
- `<root>/prettier.config.js` and `<root>/.prettierignore`

When creating comments, follow these guidelines:

- Place inline comments above the code, not on the same line.
- Use full sentences for comments.
- Add JSDoc/HereDoc if missing, but keep it short. Do not align it.
- Keep all lines, including comments, under 120 characters.
- Never comment in Markdown, except code blocks.
