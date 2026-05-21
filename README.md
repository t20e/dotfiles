# Dotfiles

This repository contains my centralized configurations for various development tools.

## Setting Up A New Machine

```bash
# 1. Install prerequisites
brew install stow git

# 2. Clone the repository
git clone https://github.com/t20e/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 3. Remove default OS files to prevent Stow conflicts
rm -f ~/.zshrc

# 4. Deploy the symlinks
stow zsh
stow ghostty
stow nvim
stow tmux
# stow anymore you want...
```

## Migrating New Tools To The Repo

> [!WARNING]
> Make sure that there are no sensitive items like API tokens, ssh keys, etc... in these configurations before sharing them with others! `Add them to .gitignore!`
>
> And only share the configurations not things like tmux plugins, they take up a lot of space!

Files are structured inside ~/.dotfiles to mirror their exact paths relative to the home directory (~/).

Example tree structure:

```text
~/.dotfiles/
    ├── zsh/
    │   └── .zshrc                  (Will link to ~/.zshrc)
    ├── nvim/
    │   └── .config/
    │       └── nvim/               (Will link to ~/.config/nvim)
    ├── etc...
    └── non_symlink_configs/        (Static backups, never stowed)
```

> [!NOTE]
> Remove the (.) from the tool_name when creating the file in ~/.dotnet
>
> **Root-level** (e.g., ZSH, Git)
>
> ```bash
> # Create the package folder in this repo
> mkdir -p ~/.dotfiles/<tool_name>
> # Move the config into this repo
> mv ~/.<original_name> ~/.dotfiles/<tool_name>/
> # Deploy the symlink
> cd ~/.dotfiles
> stow <tool_name>
> ```
>
> **Nested Configs** (e.g., tools located in ~/.config like nvim or ghostty)
>
> ```text
> ~/.config 
> ├── ghostty
> │   ├── config
> │   └── themes
> │       ├── glass_dark_theme
> │       └── glass_light_theme
> ├── nvim
> │   ├── init.lua
> etc...
> ```
>
> ```bash
> # Recreate the path structure
> mkdir -p ~/.dotfiles/<tool_name>/.config
> # Move the directory
> mv ~/.config/<tool_name> ~/.dotfiles/<tool_name>/.config/
> # Deploy the symlink
> cd ~/.dotfiles
> stow <tool_name>
> ```

### How To Undo A Stow

If you need to move a tool out of the repo and back to its original local state:

```bash
# 1. Un-stow the package (removes the symlink)
cd ~/.dotfiles
stow -D <tool_name>

# 2. Move the files back to their original location

# FOR ROOT-LEVEL CONFIGS:
mv ~/.dotfiles/<tool_name>/<original_file_name> ~/

# FOR NESTED CONFIGS (~/.config):
mv ~/.dotfiles/<tool_name>/.config/<tool_name> ~/.config/

# 3. Clean up the empty dotfiles folders
rm -rf ~/.dotfiles/<tool_name>
```
