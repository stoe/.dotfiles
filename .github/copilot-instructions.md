# Copilot Instructions for .dotfiles

This personal dotfiles repository manages MacOS development environment configurations through a modular, machine-aware system.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Coding Standards](#coding-standards)
3. [Maintenance Strategy](#maintenance-strategy)

## Architecture Overview

This is a **modular dotfiles system** with three key architectural components:

1. **Configuration Layer**: Core dotfiles (`.zshrc`, `.gitconfig`, etc.) with local overrides
2. **Package Management**: Machine-aware Homebrew setup that detects work vs personal environments
3. **AI Workflow Layer**: GitHub-based chat modes, instructions, and toolsets for different work contexts

### File Structure

```shell
.dotfiles/
├── .github/                        # GitHub configuration
│   ├── agents/                     # AI agents configurations
│   ├── instructions/               # AI behavior instructions
│   ├── prompts/                    # AI prompts
│   └── toolsets/                   # AI toolset configurations
├── .husky/                         # Git hooks (pre-commit, pre-push)
├── .vscode/                        # VS Code workspace settings
│   ├── settings.json               # Shared settings
│   ├── settings - stable.json      # VS Code stable overrides (symlink this to /Users/you/Library/Application Support/Code/User/settings.json)
│   ├── settings - insiders.json    # VS Code insiders overrides (symlink this to /Users/you/Library/Application Support/Code - Insiders/User/settings.json)
│   └── keybindings.json            # Custom keybindings (symlink this to /Users/you/Library/Application Support/{Code|Code - Insiders}/User/keybindings.json)
├── config/                         # Application-specific configurations
│   ├── .pandoc-docx/               # Pandoc Word conversion templates (git submodule)
│   ├── .pandoc-pdf/                # Pandoc PDF conversion templates (git submodule)
│   ├── gh/config.yml               # GitHub CLI config
│   └── rubocop/config.yml          # RuboCop config
├── inc/                            # Modular shell includes
│   ├── aliases.zsh                 # Command aliases
│   ├── functions.zsh               # Custom functions
│   ├── helpers.zsh                 # Helper utilities
│   └── paths.zsh                   # PATH modifications
├── scripts/                        # Executable automation
│   ├── duti                        # MacOS default app handler
│   └── brew/                       # Homebrew management
│       ├── install                 # Smart installer script
│       ├── cleanup                 # Cleanup script
│       ├── Brewfile                # Core packages
│       ├── Brewfile.work           # Work-specific packages
│       ├── Brewfile.personal       # Personal packages
│       ├── Brewfile.optional       # Optional packages
│       └── Brewfile.vsc            # VS Code extensions
├── .bash_profile                   # Bash compatibility (transition support)
├── .bashrc                         # Bash configuration
├── .gitconfig                      # Git configuration (with includes)
├── .p10k.zsh                       # Powerlevel10k theme configuration
├── .zshrc                          # Main ZSH configuration
├── ...                             # other configs
# Local Override Files (not committed, essential for customization)
├── .gitconfig-local            # Machine-specific Git settings
├── .gitconfig-{work|personal}  # Context-specific Git config
├── .gitconfig-{ghedr|msft}     # Additional context-specific configs
└── .zshrc-local                # Machine-specific shell config
```

### Code Organization

- `.github/` - AI workflow system (chatmodes, instructions, toolsets)
- `.husky/` - Git hooks for pre-commit and pre-push automation
- `.vscode/` - VS Code workspace settings (stable, insiders, shared keybindings)
- `config/` - Application-specific configurations (document conversion, CLI tools, linters)
- `inc/` - Modular shell includes (aliases, functions, helpers, paths)
- `scripts/` - Executable automation (brew management, MacOS defaults)

### Machine Detection & Setup

The `scripts/brew/install` script auto-detects machine context:

```bash
# Uses hostname to determine context
WORK_MACHINE_NAME="0x73746f65"
PERSONAL_MACHINE_NAME="6x73746f65"
```

Creates unified Brewfile from: `Brewfile` + `Brewfile.optional` + `Brewfile.{work|personal}` + `Brewfile.vsc`

### Integration Points

#### Shell Environment

- [zgen](https://github.com/tarjoilija/zgen) plugin manager loading selected [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) plugins (`.zshrc` lines 36-62) + [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
- Custom aliases emphasize safety (`rm=trash`, `rm!="/bin/rm"`)
- NPM workflow aliases for update + install + test cycles
- Bash compatibility files (`.bash_profile`, `.bashrc`) support shell transitions

#### Git Configuration

Layered config with directory-based context switching:

```properties
[include]
  path = ~/.gitconfig-local

[includeIf "gitdir/i:~/code/work/"]
  path = ~/code/work/.gitconfig-work

[includeIf "gitdir/i:~/code/ghedr/"]
  path = ~/code/ghedr/.gitconfig-ghedr
```

Supports five contexts: `local`, `personal`, `work`, `ghedr`, `msft`

#### VS Code Integration

- `.github/` AI workflow integration with GitHub Copilot
- `.vscode/` directory for workspace settings (stable, insiders, shared keybindings)
- Dedicated `scripts/brew/Brewfile.vsc` for 50+ editor extensions

#### Config Categories

- **Document Conversion**: Pandoc templates for Word (`config/.pandoc-docx/`) and PDF (`config/.pandoc-pdf/`) with custom styling
- **CLI Tools**: GitHub CLI configuration (`config/gh/config.yml`)
- **Language Tooling**: RuboCop linting rules (`config/rubocop/config.yml`)

## Coding Standards

### AI Workflow Development

- **Directory Structure**: Follow the `.github/` pattern for AI configurations
- **Naming Conventions**: Use descriptive names for chatmodes, instructions, and toolsets
- **File Organization**: Separate chatmodes, instructions, and toolsets into dedicated folders
- **Configuration Management**: Keep AI workflow configs organized and version controlled

### ZSH Shell Development

- **File Structure**: Follow the `inc/` modular pattern - separate concerns into `aliases.zsh`, `functions.zsh`, `helpers.zsh`, `paths.zsh`
- **Naming Conventions**: Use lowercase with underscores for files (`utility_functions.zsh`) and descriptive names for functions
- **Variable Scoping**: Use `typeset` for proper variable scoping in functions, avoid global variables when possible
- **Error Handling**: Always quote variables (`"$variable"`) to prevent word splitting and check exit status with `set -eo pipefail`
- **Shebang**: Start scripts with `#!/usr/bin/env zsh` (already follows this pattern in `.zshrc`)
- **Modular Loading**: Use conditional sourcing pattern: `[ -f "${DFH}/inc/file.zsh" ] && source "${DFH}/inc/file.zsh"`
- **Environment Variables**: Export `DFH` for dotfiles home path, use consistent variable naming like the existing pattern
- **Safety First**: Follow the `rm=trash` philosophy - prefer safer alternatives to destructive operations

### Environment Variables

Toolchain environment setup centralized in `inc/paths.zsh`:

- `GOPATH`, `GOBIN`, `GOROOT` - Go toolchain paths
- `PYENV_ROOT` - Python version manager
- `NVM_DIR` - Node version manager
- `GPG_TTY` - GPG terminal for signing
- Additional variables for OpenSSL, SSH auth, editor configs

### Development Workflow Standards

- **Prettier + Husky**: Auto-formatting with pre-commit hooks
- **lint-staged**: Staged file formatting (excludes copilot-instructions.md)
- **Node.js toolchain**: Uses npm for dependency management

### Local Override Pattern

Essential pattern for customization without committing sensitive data:

- `.gitconfig-local` - Personal git settings (name, email, signing key)
- `.gitconfig-{work|personal|ghedr|msft}` - Context-specific git configurations
- `.zshrc-local` - Machine-specific shell configuration

When working with this codebase, prioritize the local override pattern for sensitive configurations.

### Power Functions & Utilities

Key utilities organized by category in `inc/functions.zsh` and `inc/helpers.zsh`:

#### Update Functions

- `brewup()` - Interactive Homebrew/mas/cask updater (supports `-y` flag)
- `npmup()` - NPM global package updater with confirmation
- `ghup()` - GitHub CLI extension upgrade automation

#### Archive Utilities

- `targz()` - Smart tar.gz creation (uses 7zz/zopfli/pigz based on availability)
- `zippw()` - Password-protected zip archives via 7z
- `extract()` - Universal archive extractor for multiple formats

#### Conversion Tools

- `mov2gif()` - Video to GIF conversion with ffmpeg + ImageMagick
- `pdf2png()` - PDF to PNG with Ghostscript
- `docx2md()` - Word to Markdown via Pandoc

#### Docker Helpers

- `dstop()` - Stop all containers with confirmation
- `dclean()` - Prune stopped containers and untagged images

## Maintenance Strategy

### Review Triggers

Update this documentation when:

- **Adding shell functions** to `inc/*.zsh` - Document in Power Functions if user-facing
- **Creating new Brewfile contexts** - Update Machine Detection section and git include patterns
- **Adding git context includes** - Update Git Configuration section with new `includeIf` paths
- **Committing new config/ files** - Add to Config Categories if it represents a new category

### Quarterly Sync Check

Every ~3 months, verify:

- File structure matches committed files (run `git ls-files` comparison against File Structure section)
- Power Functions list reflects active utilities (remove deprecated tools)
- Machine names and contexts align with current setup
- Environment variables section covers key toolchain additions

### Formatting Exclusion

`copilot-instructions.md` is intentionally excluded from Prettier auto-formatting (`.prettierignore` + `lint-staged` config) to allow flexible documentation structure. Run manual formatting review before commits if structure changes significantly.

### Automation Considerations

While automated sync (e.g., parsing `inc/*.zsh` for function definitions or using `git ls-files` to generate file tree) could reduce drift, it adds tooling complexity and may produce noisy diffs. Current manual approach balances accuracy with maintenance overhead—focus on documenting high-impact features rather than exhaustive catalogs.
