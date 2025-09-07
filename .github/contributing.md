## Contributing

[fork]: /fork
[pr]: /compare

Hi there! I'm thrilled that you'd like to contribute to this project. Your help is essential for keeping it great.

## Development Setup

Before you start, you'll need:

- **macOS** (these dotfiles are macOS-specific)
- **Node.js 20+** and **npm 10+** (for prettier and git hooks)
- **zsh** as your shell

To set up the development environment:

1. Fork and clone the repository
2. Install dependencies: `npm install`
3. Test your changes carefully (see [Testing Changes](#testing-changes) below)

## Project Structure

- `config/` - Application-specific configuration files
- `inc/` - Zsh includes (aliases, functions, paths, helpers)
- `scripts/` - Installation and utility scripts
- `.github/` - GitHub-specific files (workflows, templates, etc.)
- Individual dotfiles (`.zshrc`, `.gitconfig`, etc.) in the root

## Testing Changes

**⚠️ Important:** Dotfiles can significantly change your development environment. Always test carefully:

1. **Backup your existing configs** before testing
2. **Use a test environment** or virtual machine when possible
3. **Test shell changes** by sourcing files rather than restarting your shell
4. **Verify git configs** don't break your workflow
5. **Check homebrew changes** won't install unwanted packages

## Submitting a Pull Request

1. [Fork][fork] and clone the repository
2. Create a new branch: `git checkout -b my-branch-name`
3. Make your change and test thoroughly
4. Ensure code is properly formatted: `npm run format`
5. Push to your fork and [submit a pull request][pr]
6. Pat yourself on the back and wait for your pull request to be reviewed and merged

## Code Style

This project uses [Prettier](https://prettier.io/) for consistent formatting:

- Run `npm run format` to format all files
- Pre-commit hooks will automatically format staged files
- Configuration is in `prettier.config.js`

## Areas for Contribution

Here are some areas where contributions are especially welcome:

- **New tool configurations** that integrate well with the existing setup
- **Cross-platform compatibility** improvements
- **Documentation** improvements and corrections
- **Script optimizations** for better performance or reliability
- **Bug fixes** for existing configurations

## Guidelines for Good Contributions

- **Keep changes focused** - If you have multiple unrelated improvements, submit separate PRs
- **Test on multiple machines** when possible (work vs personal configs)
- **Document breaking changes** clearly
- **Respect existing code style** and conventions
- **Write [good commit messages](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)**

Work in Progress pull requests are welcome to get feedback early on, or if there's something blocking you.

## Resources

- [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/)
- [Using Pull Requests](https://help.github.com/articles/about-pull-requests/)
- [GitHub Help](https://help.github.com)
