# stoe :green_heart: ~/

~~Stolen~~ Adopted from [various dotfiles](#thanks 'thanks'), changed and extended to my needs.

[It should have been a fork](https://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/ 'Dotfiles Are Meant to Be Forked'), but I decided against it.

## what's in the box?

This collection includes configurations for:

- **zsh** via zgen (loads selected Oh My Zsh plugins + Powerlevel10k theme)
- **git** with sensible defaults and helpful aliases
- **VS Code** settings and extensions (because who doesn't love a good editor war?)
- **homebrew** packages organized by context (work, personal, optional)
- **prettier** for keeping things looking sharp
- Various other tools and utilities that make terminal life bearable

## quick start

**Prerequisites:** You'll need macOS and a sense of adventure.

1. **Clone the repository:**

   ```bash
   git clone https://github.com/stoe/.dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Install dependencies:**

   ```bash
   npm install
   ```

3. **Run the brew setup** (this will install packages based on your machine):

   ```bash
   cd scripts/brew && ./install
   ```

   > [!NOTE]
   > You might want to review the [`cleanup`](./scripts/brew/cleanup) and [`install`](./scripts/brew/install) scripts to ensure it matches your machine names and needs.

4. **Symlink what you need** (be careful, this might overwrite existing configs):
   ```bash
   # Copy/symlink individual files as needed
   # No automated symlinking because that's how you accidentally nuke your existing setup
   ```

## customization

The beauty of dotfiles is making them your own. Key files to customize:

- **`.gitconfig-local`** for your personal git settings:

  Add private info like your name, email, and signing key for commits.

  ```properties
  [user]
    name = Your Name
    email = your.email@example.com
    signingkey = your-ssh-key-here
  ```

- **`.zshrc-local`** for machine-specific shell configuration:

  Add any aliases, exports, or functions you want to keep private or specific to this machine.

- **`scripts/brew/Brewfile.*`** for package management by context

## machine-specific configs

The brew installer is smart enough to detect your machine and install different packages:

- `Brewfile.work` for your work machine
- `Brewfile.personal` for your personal machine
- Plus shared configs for VS Code and optional packages

## thanks

- http://dotfiles.github.io/
- https://github.com/geerlingguy/dotfiles
- https://github.com/holman/dotfiles
- https://github.com/mathiasbynens/dotfiles
- https://github.com/stoeffel/.dotfiles
