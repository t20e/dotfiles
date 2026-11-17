# Dotfiles

This repository contains my centralized configurations for various development tools.

## Configure New Machine

1. Install prerequisites
- Recommended Font: [Jetbrains Mono](https://www.jetbrains.com/lp/mono/#intro)

```bash
brew install stow git
```

2. Install [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) | [PowerLevel10k](https://github.com/romkatv/powerlevel10k) | [ZSH-Autocomplete](https://formulae.brew.sh/formula/zsh-autocomplete#default)

```bash
# Install Oh-My-Zsh: 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Install PowerLevel10k:
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
# Install Zsh-Autocomplete: 
brew install zsh-autocomplete
```

3. Clone Dotfiles repo

```bash
git clone https://github.com/t20e/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

4. Stow configs

```bash
# Remove default ZSH config file, not that if you made any changes this will erase them.
rm ~/.zshrc

# Dry run to find any conflicts, if conflicts appear make sure to save those files if you don't want to overwrite them!
stow -n -v zsh powerlevel10k ghostty

# Deploy the symlinks
stow zsh powerlevel10k ghostty
# Stow anymore you want...

exec zsh

# If error `chpwd_recent_filehandler:29: no such file or directory:`
#     Run: mkdir -p ~/.local/share/zsh
```

## Stowing New Tools To Dotfiles

Files must mirror their exact path relative to your home directory (`~/`).

> [!WARNING]
> Make sure that there are no sensitive items like API tokens, ssh keys, etc... in these configurations before stowing! Add them to .gitignore, or selectively only store the config file.
>
> Most of the time we only want the config file of the tool. Avoid saving local states, caches, databases, or third-party plugin binaries. Note though that some plugins like Neovim plugins files like (init.lua, lua/) (**Not their binaries!**) should be stowed.

### Workflow A: Stowing an Entire Config Directory (e.g., Neovim, Ghostty)

- Use this for tools that store only configuration files inside a dedicated folder. Example (Ghostty):

    ```text
    .config/ghostty
    ├── config
    └── themes
        ├── glass_dark_theme
        └── glass_light_theme
    ```

```bash
TOOL="ghostty"

# Recreate the ~/.config default OS directory inside the ~/.dotfiles
mkdir -p ~/.dotfiles/$TOOL/.config

# Move the config into ~/.dotfiles
mv ~/.config/$TOOL ~/.dotfiles/$TOOL/.config/

# Deploy the symlink
cd ~/.dotfiles && stow $TOOL
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

# Recreate the target hidden directory structure inside the ~/.dotfiles
mkdir -p ~/.dotfiles/$TOOL/.$TOOL

# Move only the config file into ~/.dotfiles
mv ~/.$TOOL/$CONFIG_FILE ~/.dotfiles/$TOOL/.$TOOL/

# Deploy the symlink
cd ~/.dotfiles && stow $TOOL
```

### Workflow C: Stowing a dedicated root level config (e.g., ZSH)

- Example:

    ```text
    ~ (Home Directory)
    ├── ...
    ├── ~/.zshrc
    etc...
    ```

```bash
TOOL="zsh"
CONFIG_FILE=".zshrc"

mkdir -p ~/.dotfiles/$TOOL/
mv ~/$CONFIG_FILE ~/.dotfiles/$TOOL/
cd ~/.dotfiles && stow $TOOL
```

## How To Undo A Stow

If you need to completely remove a tool from the repository and restore it to its original local state:

**Example Nested Configs:** Unstowing Ghostty

```bash
TOOL="ghostty"

cd ~/.dotfiles && stow -D $TOOL
mv ~/.dotfiles/$TOOL/.config/$TOOL ~/.config/
rm -rf ~/.dotfiles/$TOOL
```

**Example Home Root Configs:** Unstowing ZSH

```bash
TOOL="zsh"
CONFIG_FILE=".zshrc"

cd ~/.dotfiles && stow -D $TOOL
mv ~/.dotfiles/$TOOL/$CONFIG_FILE ~/
rm -rf ~/.dotfiles/$TOOL
```

If you only want to remove the symlink and leave the configuration inside ~/.dotfiles:

```bash
TOOL="zsh"

cd ~/.dotfiles && stow -D $TOOL
```
