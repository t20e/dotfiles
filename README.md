# Dotfiles

This repository contains my centralized configurations for various development tools.

## Setting Up A New Machine

```bash
# 1. Install prerequisites
brew install stow git

# 2. Clone the repository
git clone https://github.com/t20e/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 3. Remove default OS files to prevent Stow conflicts
rm -f ~/.zshrc
# etc...

# 4. Deploy the symlinks
stow zsh
stow ghostty
# stow anymore you want...
```

## Stowing New Tools To Dotfiles

Files must mirror their exact path relative to your home directory (`~/`).

> [!WARNING]
> Make sure that there are no sensitive items like API tokens, ssh keys, etc... in these configurations before stowing! Add them to .gitignore, or selectively only store the config file.
>
> Most of the time we only want the config file of the tool. Avoid saving local states, caches, databases, or third-party plugin binaries. Note though that some plugins like Neovim plugins files like (init.lua, lua/) (**Not their binaries!**) should be stowed.

### Workflow A: Stowing an Entire Config Directory (e.g., Neovim, Ghostty)

- Use this for tools that store only configuration files inside a dedicated folder. Example:

    ```text
    .config/ghostty
    ├── config
    └── themes
        ├── glass_dark_theme
        └── glass_light_theme
    ```

```bash
TOOL="ghostty"

# Recreate the ~/.config default OS directory inside the ~/dotfiles
mkdir -p ~/dotfiles/$TOOL/.config

# Move the config into ~/dotfiles
mv ~/.config/$TOOL ~/dotfiles/$TOOL/.config/

# Deploy the symlink
cd ~/dotfiles && stow $TOOL
```

### Workflow B: Stowing a Targeted File (e.g., Apps with messy folders)

- Use this when a tool's home folder is cluttered with caches, histories, or databases, and you only want to sync the primary configuration file. Unnecessary items are auto generated later. Example:

    ```text
    .continue
    ├── config.ts
    ├── config.yaml # Only this config is necessary
    etc...
    ```

```bash
TOOL="continue"
CONFIG_FILE="config.yaml"

# Recreate the target hidden directory structure inside the ~/dotfiles
mkdir -p ~/dotfiles/$TOOL/.$TOOL

# Move only the config file into ~/dotfiles
mv ~/.$TOOL/$CONFIG_FILE ~/dotfiles/$TOOL/.$TOOL/

# Deploy the symlink
cd ~/dotfiles && stow $TOOL
```

### Workflow C: Stowing a dedicated root level config (e.g., ZSH)

- Example:

    ```text
    ~ (home dir)
    ├── ...
    ├── ~/.zshrc
    etc...
    ```

```bash
TOOL="zsh"
CONFIG_FILE=".zshrc"

mkdir -p ~/dotfiles/$TOOL/
mv ~/$CONFIG_FILE ~/dotfiles/$TOOL/
cd ~/dotfiles && stow $TOOL
```

## How To Undo A Stow

If you need to completely remove a tool from the repository and restore it to its original local state:

**Example Nested Configs:** Unstowing Ghostty

```bash
TOOL="ghostty"

cd ~/dotfiles && stow -D $TOOL
mv ~/dotfiles/$TOOL/.config/$TOOL ~/.config/
rm -rf ~/dotfiles/$TOOL
```

**Example Home Root Configs:** Unstowing ZSH

```bash
TOOL="zsh"
CONFIG_FILE=".zshrc"

cd ~/dotfiles && stow -D $TOOL
mv ~/dotfiles/$TOOL/$CONFIG_FILE ~/
rm -rf ~/dotfiles/$TOOL
```

If you only want to remove the symlink and leave the configuration inside ~/dotfiles:

```bash
TOOL="zsh"

cd ~/dotfiles && stow -D $TOOL
```
