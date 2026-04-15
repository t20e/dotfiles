

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load zsh-autocomplete (https://github.com/marlonrichert/zsh-autocomplete)
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh


# Make the zcompdump into a directory instead of the file being dumped into the home directory.
mkdir -p "$HOME/.cache/zsh/zcompdumps"
export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdumps/.zcompdump"


# >>> Conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/tonyavis/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/tonyavis/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/tonyavis/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/tonyavis/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<




# ====================== Oh My Zsh ======================
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_THEME="robbyrussell"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-syntax-highlighting
  )

source $ZSH/oh-my-zsh.sh


# ====================== NVM configurations ======================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion



# ====================== User configuration ======================
# BUG FIX: had an issue with zsh ctrl+q shortcut this line overrides that shortcut!
bindkey '^Q' backward-kill-line

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# config for zsh-autocomplete
bindkey              '^I'         menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete
# 


# Created by `pipx` on 2026-04-06 21:41:16
# pipx paths
export PATH="$PATH:/Users/tonyavis/.local/bin"
