# Copilot Instructions for .dotfiles

This personal dotfiles repository manages MacOS development environment configurations through a modular, machine-aware system.

<details><summary>Table of Contents</summary>

- [Architecture Overview](#architecture-overview)
  - [File Structure](#file-structure)
  - [Code Organization](#code-organization)
  - [Machine Detection \& Setup](#machine-detection--setup)
  - [Integration Points](#integration-points)
- [Coding Standards](#coding-standards)
  - [AI Workflow Development](#ai-workflow-development)
  - [Fish Shell Development](#fish-shell-development)
  - [Environment Variables](#environment-variables)
  - [Development Workflow Standards](#development-workflow-standards)
  - [Local Override Pattern](#local-override-pattern)
  - [Power Functions \& Utilities](#power-functions--utilities)
- [Maintenance Strategy](#maintenance-strategy)
  - [Review Triggers](#review-triggers)
  - [Quarterly Sync Check](#quarterly-sync-check)
  - [Formatting Exclusion](#formatting-exclusion)
  - [Automation Considerations](#automation-considerations)

</details>

## Architecture Overview

This is a **modular dotfiles system** with three key architectural components:

1. **Configuration Layer**: Core dotfiles (`config/fish/`, `.gitconfig`, etc.) with local overrides
2. **Package Management**: Machine-aware Homebrew setup that detects work vs personal environments
3. **AI Workflow Layer**: GitHub-based chat modes, instructions, and toolsets for different work contexts

> [!NOTE]
> This repo migrated from zsh/zgen/Oh My Zsh/Powerlevel10k to fish/Fisher/fzf.fish/Tide (branch `stoe/fish`). `config/fish/` is the primary, actively maintained shell configuration, and fish is the default shell. The legacy zsh (`.zshrc`, `.zprofile`, `.zlogin`, `inc/*.zsh`, `.p10k.zsh`) and bash (`.bash_profile`, `.bashrc`, `.git-completion.bash`, `.git-prompt.sh`) files have been fully removed after confirming every alias/function/PATH setting was ported.

### File Structure

```shell
.dotfiles/
├── .github/                        # GitHub configuration
│   ├── agents/                     # AI agents configurations
│   ├── instructions/               # AI behavior instructions
│   ├── prompts/                    # AI prompts
│   ├── skills/                     # AI skills
│   └── toolsets/                   # AI toolset configurations
│
├── .husky/                         # Git hooks (pre-commit, pre-push)
│
├── .vscode/                        # VS Code workspace settings
│   ├── settings.json               # Shared settings
│   ├── settings - stable.json      # VS Code stable overrides (symlink this to /Users/you/Library/Application Support/Code/User/settings.json)
│   ├── settings - insiders.json    # VS Code insiders overrides (symlink this to /Users/you/Library/Application Support/Code - Insiders/User/settings.json)
│   └── keybindings.json            # Custom keybindings (symlink this to /Users/you/Library/Application Support/{Code|Code - Insiders}/User/keybindings.json)
│
├── config/                         # Application-specific configurations
│   ├── .pdfpw/                     # PDF password protection (git submodule)
│   ├── .zippw/                     # ZIP password protection (git submodule)
│   ├── fish/                       # Primary shell config (fish + Fisher + Tide + fzf.fish)
│   │   ├── config.fish             # Top-level fish config (GitHub CLI completion, etc.)
│   │   ├── conf.d/                 # Numbered auto-loaded startup files (00-dfh, 05-homebrew, 10-paths, 15-colors, 20-environment, 30-git-abbr, 35-ls, 40-toolchains, 50-fzf, 55-tide-config, 90-local)
│   │   ├── functions/               # Autoloaded fish functions (aliases, helpers, openers, update tools, conversion tools, pdfpw/zippw)
│   │   ├── completions/            # Fisher-managed completions
│   │   └── fish_plugins            # Fisher plugin manifest (jorgebucaran/fisher, patrickf1/fzf.fish, ilancosman/tide)
│   ├── gh/config.yml               # GitHub CLI config
│   └── rubocop/config.yml          # RuboCop config
│
├── script/                         # Executable automation (fish scripts)
│   ├── duti                        # MacOS default app handler
│   └── brew/                       # Homebrew management
│       ├── install                 # Smart installer script
│       ├── cleanup                 # Cleanup script
│       ├── Brewfile                # Core packages
│       ├── Brewfile.work           # Work-specific packages
│       ├── Brewfile.personal       # Personal packages
│       ├── Brewfile.optional       # Optional packages
│       └── Brewfile.vsc            # VS Code extensions
│
├── .editor                         # Default editor configuration
├── .editorconfig                   # EditorConfig standard (cross-editor formatting)
├── .gitattributes                  # Git attributes (line endings, diff handling)
├── .gitconfig                      # Git configuration (with includes)
├── .gitmodules                     # Git submodules configuration
├── .prettierignore                 # Prettier formatter exclusions
├── package.json                    # NPM project metadata
├── prettier.config.js              # Prettier formatter configuration
├── readme.md                       # Repository documentation
├── license                         # MIT License
│
│   # Local Override Files (symlinked in from ~/Documents/.dotfiles/, gitignored)
├── .gitconfig.local            # Default identity (per-machine symlink target)
├── .gitconfig.personal.local   # Personal Git settings (~/code/private/)
├── .gitconfig.github.local     # Work-context Git config
├── .gitconfig.{ghedr|msft}.local # Additional context-specific configs
└── .config.personal.local.fish # Machine-specific fish config, sourced by config/fish/conf.d/90-local.fish
```

### Code Organization

**Primary Directories:**

- `.github/` - AI workflow system (agents, instructions, prompts, toolsets) + GitHub metadata (issue templates, code of conduct, contributing guidelines, codeowners)
- `.husky/` - Git hooks for pre-commit and pre-push automation
- `.vscode/` - VS Code workspace settings (stable, insiders, shared keybindings, snippets, extensions)
- `config/fish/` - Primary shell configuration: conf.d startup files, autoloaded functions, Fisher plugin manifest
- `config/` - Other application-specific configurations (document conversion, CLI tools, linters)
- `script/` - Executable automation (brew management, MacOS defaults, duti) — now fish scripts

**Configuration Files:**

- `.editorconfig` - Cross-editor formatting standards
- `.gitattributes` - Git line ending and diff settings
- `.gitmodules` - Submodule references (Pandoc templates)
- `.prettierignore` - Prettier exclusions
- `prettier.config.js` - Code formatter configuration

**Shell Initialization Files:**

- `config/fish/config.fish` - Top-level fish config (interactive-only setup, e.g. `gh completion -s fish`)
- `config/fish/conf.d/*.fish` - Numbered, auto-loaded startup files (DFH self-detection, Homebrew shellenv, PATH, colors, environment, git abbreviations, GNU ls overrides, toolchain hooks, fzf bindings, Tide bootstrap, local overrides)

### Machine Detection & Setup

The `script/brew/install` script auto-detects machine context:

```bash
# Uses hostname to determine context
WORK_MACHINE_NAME="0x73746f65"
PERSONAL_MACHINE_NAME="6x73746f65"
```

Creates unified Brewfile from: `Brewfile` + `Brewfile.optional` + `Brewfile.{work|personal}` + `Brewfile.vsc`

### Integration Points

#### Shell Environment

- [Fisher](https://github.com/jorgebucaran/fisher) plugin manager loading [`PatrickF1/fzf.fish`](https://github.com/PatrickF1/fzf.fish) and the [Tide](https://github.com/IlanCosman/tide) prompt (`config/fish/fish_plugins`)
- `~/.config` is a pre-existing symlink to `$DFH/config`, so `config/fish/` is automatically the live `~/.config/fish/` — no additional symlink needed for fish itself
- Custom aliases/functions emphasize safety (`rm` → `trash`, `rm!` → real `/bin/rm`); `trash` comes from the keg-only `macos-trash` formula, PATH-prepended in `conf.d/10-paths.fish` so it wins over any npm-installed `trash-cli`
- `ls`/`l`/`ll`/`la` are overridden to GNU coreutils' `gls` when installed (`config/fish/conf.d/35-ls.fish`); without coreutils, fish's own colorized `ls` wrapper is used instead
- NPM workflow aliases/functions for update + install + test cycles (`npmup`, `ncua`, `ncua!`)
- SSH auth standardized on the 1Password SSH agent (`config/fish/conf.d/20-environment.fish`), resolving a former race condition between `ssh-agent` and yubikey-agent
- Legacy zsh (`.zshrc`, `.zprofile`, `.zlogin`, `inc/*.zsh`, `.p10k.zsh`) and bash (`.bash_profile`, `.bashrc`, `.git-completion.bash`, `.git-prompt.sh`) files have all been removed — fish covers everything they provided

##### Oh My Zsh plugin replacements

The old `.zshrc` loaded the Oh My Zsh core lib plus ten plugins via zgen. Fish covers most of it natively; only the `git` plugin's aliases and the lib's `d` needed porting:

| Oh My Zsh plugin                    | Fish equivalent                                                                                                                   |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `plugins/git`                       | `config/fish/conf.d/30-git-abbr.fish` - `g`, `ga`, `gc`, `gp` … 32 abbreviations covering the subset actually used, plus siblings |
| `plugins/gitignore`                 | `gi` function (`config/fish/functions/gi.fish`)                                                                                   |
| `plugins/brew`                      | Fish ships `brew` completions; the plugin's aliases weren't used                                                                  |
| `plugins/node`                      | Fish ships `node`/`npm` completions; `npmup`/`npmls`/`npmla`/`npmll` are custom functions                                         |
| `plugins/fnm`                       | `fnm env --use-on-cd --shell fish` in `conf.d/40-toolchains.fish`                                                                 |
| `plugins/git-extras`                | Completions only; commands themselves come from the `git-extras` formula                                                          |
| `plugins/git-lfs`                   | Aliases only, unused; `git lfs` works unchanged                                                                                   |
| `plugins/macos`                     | Only `cdf` was ever used (once); not ported                                                                                       |
| `zgen oh-my-zsh` (the omz **lib**)  | Mostly native in fish (`..`/`...`, `prevd`/`nextd`, `cd -`, `cdh`); `d` is ported to `config/fish/functions/d.fish`               |
| `zsh-users/zsh-syntax-highlighting` | Built into fish - no plugin required                                                                                              |

`gs`, `gls` and `gcp` are deliberately **not** defined as git abbreviations: on this machine they resolve to ghostscript, coreutils' `gls` and coreutils' `gcp`.

#### Git Configuration

Layered config with directory-based context switching:

```properties
[include]
  path = ~/code/private/.dotfiles/.gitconfig.local

[includeIf "gitdir/i:~/code/private/"]
  path = ~/code/private/.dotfiles/.gitconfig.personal.local

[includeIf "gitdir/i:~/code/work/"]
  path = ~/code/private/.dotfiles/.gitconfig.github.local

[includeIf "gitdir/i:~/code/ghedr/"]
  path = ~/code/private/.dotfiles/.gitconfig.ghedr.local
```

Supports contexts: default (`[include]` + `~/code/scratch/`), `personal` (`~/code/private/`), `work`, `ghedr`, `msft`. Every include resolves to a gitignored symlink in `$DFH` pointing at `~/Documents/.dotfiles/` (see Local Override Pattern below).

`.gitconfig.local` is the machine-neutral default identity: it points at `.gitconfig.personal.local` on the personal machine and `.gitconfig.github.local` on the work machine. `script/setup` selects the target by hostname and prints a manual `ln -sfn` command when it cannot tell.

> [!WARNING]
> Every `[include]`/`[includeIf]` target must exist. If none resolves, `user.signingkey` is undefined and **all** commits fail with `fatal: either user.signingkey or gpg.ssh.defaultKeyCommand needs to be configured`. Verify with `git config --get user.signingkey` after changing this block.

#### VS Code Integration

- `.github/` AI workflow integration with GitHub Copilot
- `.vscode/` directory for workspace settings (stable, insiders, shared keybindings)
- Dedicated `script/brew/Brewfile.vsc` for 50+ editor extensions

#### GitHub Workflow Integration

- **Issue Templates**: `.github/ISSUE_TEMPLATE/config.yml` - GitHub issue template configuration
- **Code Governance**: `.github/codeowners` - Automatic code review assignments
- **Contributing Guidelines**: `.github/contributing.md` - Contribution standards
- **Code of Conduct**: `.github/code_of_conduct.md` - Community guidelines
- **Copilot Integration**: `.github/copilot.sh` - Shell integration for AI workflows

#### Config Categories

- **Password Protection**: Ghostscript/7z-based utilities (git submodules)
  - `config/.pdfpw/` - PDF password protection with `pdfpw` function
  - `config/.zippw/` - ZIP password protection with `zippw` function
- **CLI Tools**: GitHub CLI configuration (`config/gh/config.yml`)
- **Language Tooling**: RuboCop linting rules (`config/rubocop/config.yml`)

#### VS Code Extensions & Snippets

- `.vscode/extensions/.gitkeep` - Extensions directory placeholder
- `.vscode/snippets/markdown.json` - Markdown code snippets
- `.vscode/snippets/stoe.code-snippets` - Custom workspace snippets
- `script/brew/Brewfile.vsc` - 50+ VS Code extensions installation

## Coding Standards

### AI Workflow Development

- **Directory Structure**: Follow the `.github/` pattern for AI configurations
- **Naming Conventions**: Use descriptive names for chatmodes, instructions, and toolsets
- **File Organization**: Separate chatmodes, instructions, and toolsets into dedicated folders
- **Configuration Management**: Keep AI workflow configs organized and version controlled

### Fish Shell Development

- **File Structure**: Follow the `config/fish/` modular pattern - numbered `conf.d/*.fish` for auto-loaded startup logic, one function per file under `functions/` (fish autoloads by filename)
- **Naming Conventions**: Use lowercase filenames matching the function/command name exactly (`brewup.fish` defines `brewup`); prefix private helper functions with an underscore (`_pdfpw_usage`)
- **Variable Scoping**: Use `set -l` for local/function scope, `set -g` for script-global, `set -gx` for exported environment variables, `set -U` only for genuine cross-session state (e.g. Tide's prompt config) — avoid unscoped `set`
- **Error Handling**: Always quote variables (`"$variable"`) to prevent word splitting; use `and`/`or` for command chaining instead of `&&`/`||`; avoid concatenating a string literal directly onto a variable followed by `[` (e.g. `"$var[abc]"`) — fish parses that as array indexing, not string interpolation
- **Command substitution gotcha**: `(some_multiline_output)` inside a larger string/list expression triggers cartesian-style expansion in fish (one output element per iteration) rather than a single joined string — build up a fish list and `string join \n -- $list` only once, right before use, instead of repeatedly concatenating with embedded `\n` escapes
- **Shebang**: Start scripts with `#!/usr/bin/env fish`
- **Abbreviations vs functions**: `abbr` is a line-editor feature — it only expands while typing interactively, so an abbreviation is _not_ a usable command in scripts, `fish -c`, or eval'd command strings. Use `abbr` for the interactive convenience (the expansion is visible before running), and add a matching `--wraps` function when the name also needs to work non-interactively; the two coexist, with the abbreviation winning in interactive shells. See `g` (`conf.d/30-git-abbr.fish` + `functions/g.fish`)
- **Modular Loading**: `conf.d/*.fish` files are auto-sourced by fish on every shell startup (no manual `source` needed); guard local-override sourcing with `if test -f ...`. Note they are read **only** at startup — after editing one, run `reload!` or open a new shell, otherwise existing sessions won't see the change
- **Environment Variables**: `DFH` self-derives from `config/fish/conf.d/00-dfh.fish`'s own resolved location (via `status current-filename` + `realpath`) rather than being hardcoded, so it survives the repo being cloned to a different path
- **Safety First**: Follow the `rm` → `trash` philosophy - prefer safer alternatives to destructive operations

### Environment Variables

Toolchain environment setup centralized in `config/fish/conf.d/10-paths.fish` and `20-environment.fish`:

- `GOPATH`, `GOBIN`, `GOROOT` - Go toolchain paths (set in `10-paths.fish` since PATH assembly depends on them)
- `PYENV_ROOT` - Python version manager
- `GPG_TTY` - GPG terminal for signing
- `SSH_AUTH_SOCK` - Points at the 1Password SSH agent socket
- Additional variables for OpenSSL (`openssl@4`), editor configs

### Development Workflow Standards

- **Prettier + Husky**: Auto-formatting with pre-commit hooks
- **lint-staged**: Staged file formatting (excludes copilot-instructions.md)
- **Node.js toolchain**: Uses npm for dependency management

### Local Override Pattern

Essential pattern for customization without committing sensitive data. Real files live outside the repo in `~/Documents/.dotfiles/` and are symlinked into `$DFH` (gitignored) under matching dot-separated names:

- `$DFH/.gitconfig.local` - Default identity for this machine; symlinked to `~/Documents/.dotfiles/.gitconfig.personal.local` on the personal machine and `.gitconfig.github.local` on the work machine. Used by `[include]` and the `~/code/scratch/` context
- `$DFH/.gitconfig.personal.local` - Personal git settings (name, email, signing key); symlinked from `~/Documents/.dotfiles/.gitconfig.personal.local`
- `$DFH/.gitconfig.github.local` - Work-context git configuration; symlinked from `~/Documents/.dotfiles/.gitconfig.github.local`
- `$DFH/.gitconfig.{ghedr|msft}.local` - Additional context-specific configs; symlinked from `~/Documents/.dotfiles/`
- `$DFH/.config.personal.local.fish` - Machine-specific fish configuration; symlinked from `~/Documents/.dotfiles/.config.personal.local.fish`; sourced automatically (if present) by `config/fish/conf.d/90-local.fish`

When working with this codebase, prioritize the local override pattern for sensitive configurations.

### Power Functions & Utilities

Key utilities organized as one autoloaded function per file under `config/fish/functions/`:

#### Update Functions

- `brewup()` - Interactive Homebrew/mas/cask updater (supports `-y` flag)
- `npmup()` - NPM global package updater with confirmation
- `ghup()` - GitHub CLI extension upgrade automation

#### Navigation

- `d()` - List the ten most recently visited directories, numbered by how many steps back they are; jump with `prevd N` (fish has no `cd -N`). Reads `$dirprev` (fish's cd history) rather than `dirs`, which in fish only tracks explicit `pushd`

#### Archive Utilities

- `targz()` - Smart tar.gz creation (uses 7zz/pigz/gzip based on availability)
- `extract()` - Universal archive extractor for multiple formats
- `zippw()` - Password-protected zip archives via 7z + 1Password integration (fish port of the `.zippw` submodule's zsh script)

#### Conversion Tools

- `mov2gif()` - Video to GIF conversion with ffmpeg + ImageMagick
- `pdf2png()` - PDF to PNG with Ghostscript
- `docx2md()` - Word to Markdown via Pandoc
- `pdfpw()` - PDF password protection with Ghostscript + 1Password integration (fish port of the `.pdfpw` submodule's zsh script)
- `gi()` - Fetch a `.gitignore` template from gitignore.io
- `ghstackview()` / `gsv` - List gh-stack branches with needsRebase status

#### Docker Helpers

- `dstop()` - Stop all containers with confirmation
- `dclean()` - Prune stopped containers and untagged images

> [!NOTE]
> The `.pdfpw`/`.zippw` git submodules (`config/.pdfpw/pdfpw.zsh`, `config/.zippw/zippw.zsh`) remain zsh-only reference implementations in their own upstream repos; the fish functions above are independent reimplementations for the interactive fish shell, not generated from the submodules.

## Maintenance Strategy

### Review Triggers

Update this documentation when:

- **Adding shell functions** to `config/fish/functions/` - Document in Power Functions if user-facing
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

While automated sync (e.g., parsing `config/fish/functions/*.fish` for function definitions or using `git ls-files` to generate file tree) could reduce drift, it adds tooling complexity and may produce noisy diffs. Current manual approach balances accuracy with maintenance overhead—focus on documenting high-impact features rather than exhaustive catalogs.
