# Copilot Instructions for .dotfiles

This personal dotfiles repository manages macOS development environment configurations through a modular, machine-aware system.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Coding Standards](#coding-standards)

## Architecture Overview

This is a **modular dotfiles system** with three key architectural components:

1. **Configuration Layer**: Core dotfiles (`.zshrc`, `.gitconfig`, etc.) with local overrides
2. **Package Management**: Machine-aware Homebrew setup that detects work vs personal environments
3. **AI Workflow Layer**: GitHub-based chat modes, instructions, and toolsets for different work contexts

### File Structure

```shell
.dotfiles/
├── .github/                        # GitHub configuration
│   ├── chatmodes/                  # AI chat mode configurations
│   ├── instructions/               # AI behavior instructions
│   ├── prompts/                    # AI prompts
│   └── toolsets/                   # AI tool configurations
├── config/                         # Application-specific configurations
│   ├── gh/                         # GitHub CLI config
│   ├── rubocop/                    # RuboCop config
│   └── ...                         # Other app configs
├── inc/                            # Modular shell includes
│   ├── aliases.zsh                 # Command aliases
│   ├── functions.zsh               # Custom functions
│   ├── helpers.zsh                 # Helper utilities
│   └── paths.zsh                   # PATH modifications
├── scripts/                        # Executable automation
│   └── brew/                       # Homebrew management
│       ├── install                 # Smart installer script
│       ├── cleanup                 # Cleanup script
│       ├── Brewfile                # Core packages
│       ├── Brewfile.work           # Work-specific packages
│       ├── Brewfile.personal       # Personal packages
│       ├── Brewfile.optional       # Optional packages
│       └── Brewfile.vsc            # VS Code extensions
├── .gitconfig                      # Git configuration (with includes)
├── .p10k.zsh                       # Powerlevel10k theme configuration
├── .zshrc                          # Main ZSH configuration
├── ...                             # other configs
# Local Override Files (not committed)
├── .gitconfig-local            # Personal git settings
├── .gitconfig-{work|personal}  # Context-specific git config
└── .zshrc-local                # Machine-specific shell config
```

### Code Organization

- `.github/` - AI workflow system (chatmodes, instructions, toolsets)
- `config/` - Application-specific configurations
- `inc/` - Modular shell includes (aliases, functions, helpers, paths)
- `scripts/` - Executable automation (brew management)

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

- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) + [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme integration
- Custom aliases emphasize safety (`rm=trash`, `rm!="/bin/rm"`)
- NPM workflow aliases for update + install + test cycles

#### Git Configuration

- Layered config: `.gitconfig` + `.gitconfig-{local|work|personal}`
- Smart context switching between work/personal identities

#### VS Code Integration

- `.github/` AI workflow integration with GitHub Copilot
- `.vscode/` directory for workspace settings
- Dedicated `scripts/brew/Brewfile.vsc` for editor extensions

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

### Development Workflow Standards

- **Prettier + Husky**: Auto-formatting with pre-commit hooks
- **lint-staged**: Staged file formatting (excludes copilot-instructions.md)
- **Node.js toolchain**: Uses npm for dependency management

### Local Override Pattern

Essential pattern for customization without committing sensitive data:

- `.gitconfig-local` - Personal git settings (name, email, signing key)
- `.zshrc-local` - Machine-specific shell configuration

When working with this codebase, prioritize the local override pattern for sensitive configurations.
