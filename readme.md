# stoe :green_heart: ~/

~~Stolen~~ Adopted from [various dotfiles](#thanks 'thanks'), changed and extended to my needs.

[It should have been a fork](https://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/ 'Dotfiles Are Meant to Be Forked'), but I decided against it.

## what's in the box?

This collection includes configurations for:

- **fish** via [Fisher](https://github.com/jorgebucaran/fisher) (loads [`PatrickF1/fzf.fish`](https://github.com/PatrickF1/fzf.fish) and the [Tide](https://github.com/IlanCosman/tide) prompt)
- **git** with sensible defaults, helpful aliases and fish abbreviations (`config/fish/conf.d/30-git-abbr.fish`, replacing the Oh My Zsh `git` plugin)
- **VS Code** settings and extensions (because who doesn't love a good editor war?)
- **homebrew** packages organized by context (work, personal, optional)
- **prettier** for keeping things looking sharp
- Various other tools and utilities that make terminal life bearable

## quick start

**Prerequisites:** You'll need macOS and a sense of adventure.

1. **Clone the repository:**

   ```bash
   git clone https://github.com/stoe/.dotfiles.git ~/code/private/.dotfiles
   cd ~/code/private/.dotfiles
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

4. **Symlink your fish config** — `~/.config` should be a symlink to `$DFH/config` so `config/fish/` becomes your live `~/.config/fish/`:

   ```bash
   ln -s "$DFH/config" ~/.config
   ```

5. **Bootstrap [Fisher](https://github.com/jorgebucaran/fisher)** and install the pinned plugins (`PatrickF1/fzf.fish`, `IlanCosman/tide`):

   ```fish
   curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
   fisher install jorgebucaran/fisher
   fisher update
   ```

6. **Make fish your default shell:**

   ```bash
   # Homebrew's fish isn't in /etc/shells by default — add it once, then chsh.
   echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
   chsh -s "$(command -v fish)"
   ```

7. **Symlink what you need** (be careful, this might overwrite existing configs):
   ```bash
   # Copy/symlink individual files as needed
   # No automated symlinking because that's how you accidentally nuke your existing setup
   ```

## customization

The beauty of dotfiles is making them your own. Local/private overrides live outside this repo (in `~/Documents/.dotfiles/`) and are symlinked into `$DFH` under their real filenames so the content itself is never committed:

- **`$DFH/.gitconfig.local`** for the default (machine-wide) git identity:

  This is the machine-neutral default, included unconditionally (`[include]`) and for repos under `~/code/scratch/`. Symlink it to whichever identity that machine should default to:

  | Machine  | Symlink target                                    |
  | -------- | ------------------------------------------------- |
  | personal | `~/Documents/.dotfiles/.gitconfig.personal.local` |
  | work     | `~/Documents/.dotfiles/.gitconfig.github.local`   |

  `script/setup` picks the right target from your hostname; if it can't tell which machine it's on, it prints the `ln -sfn` command to run manually.

- **`$DFH/.gitconfig.personal.local`** for your personal git settings:

  Symlink this to a private file (e.g. `~/Documents/.dotfiles/.gitconfig.personal.local`) containing private info like your name, email, and signing key for commits.

  ```properties
  [user]
    name = Your Name
    email = your.email@example.com
    signingkey = your-ssh-key-here
  ```

  Included for repos under `~/code/private/` (`[includeIf]`) — see `.gitconfig`.

- **`$DFH/.gitconfig.github.local`** for work-context git settings:

  Symlink this to `~/Documents/.dotfiles/.gitconfig.github.local`; included for repos under `~/code/work/`.

- **`$DFH/.config.personal.local.fish`** for machine-specific shell configuration:

  Symlink this to `~/Documents/.dotfiles/.config.personal.local.fish`. Add any abbreviations, exports, or functions you want to keep private or specific to this machine. Sourced automatically (if present) by `config/fish/conf.d/90-local.fish`.

- **`$DFH/.zshrc.personal.local`** — the legacy zsh equivalent, kept only while the zsh files remain as a fallback

- **`scripts/brew/Brewfile.*`** for package management by context

> [!IMPORTANT]
> None of the `$DFH/.gitconfig.*.local`, `$DFH/.config.personal.local.fish`, `$DFH/.zshrc.personal.local` files are tracked by git — they're gitignored symlinks pointing outside the repo. Create the symlinks yourself, e.g.:
>
> ```bash
> ln -s ~/Documents/.dotfiles/.gitconfig.personal.local "$DFH/.gitconfig.personal.local"
> ln -s ~/Documents/.dotfiles/.gitconfig.github.local "$DFH/.gitconfig.github.local"
> ln -s ~/Documents/.dotfiles/.config.personal.local.fish "$DFH/.config.personal.local.fish"
>
> # Default identity for this machine — use .gitconfig.github.local on a work machine
> ln -sfn ~/Documents/.dotfiles/.gitconfig.personal.local "$DFH/.gitconfig.local"
> ```

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
