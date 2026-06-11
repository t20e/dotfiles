

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Make tools save their configurations inside of ~/.config instead of just any where in the file system. This keeps the file system not cluttered
export XDG_CONFIG_HOME="$HOME/.config"


# Make the zcompdump into a directory instead of the file being dumped into the home directory.
mkdir -p "$HOME/.cache/zsh/zcompdumps"
export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdumps/.zcompdump"




# >>> conda initialize >>>
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



# ====================== zsh-autocomplete Config ======================
# Load the plugin first so we can override its behavior
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# FIX TAB CYCLE: Force Tab to cycle forwards and Shift+Tab to cycle backwards through the menu
bindkey '^I' menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete

# Custom Conda Sorting: Sorts environments by frequency in history, drops 'base' to the bottom
_custom_conda_env_list() {
  local -a history_envs actual_envs final_envs
  
  # 1. Grab envs from recent history, count frequency, sort highest first (exclude base)
  history_envs=($(fc -ln -1000 | grep -E 'conda activate|conda deactivate' | awk '{print $3}' | grep -v 'base' | awk 'NF' | sort | uniq -c | sort -nr | awk '{print $2}'))
  
  # 2. Get all currently existing conda envs
  if (( $+commands[conda] )); then
    actual_envs=($(conda env list | grep -v '^#' | awk '{print $1}'))
  fi

  # 3. Build ordered list: Frequent envs first
  for env in $history_envs; do
    if (($actual_envs[(Ie)$env])); then
      final_envs+=($env)
    fi
  done
  # Append remaining active envs
  for env in $actual_envs; do
    if [[ "$env" != "base" ]] && (( ! $final_envs[(Ie)$env] )); then
      final_envs+=($env)
    fi
  done
  # Append 'base' at the absolute end
  if (($actual_envs[(Ie)base])); then
    final_envs+=(base)
  fi

  # Pass the sorted list to ZSH completion without alphabetical re-sorting (-V)
  compadd -V environments -a final_envs
}

# Teach ZSH's completion system to use our custom function specifically for conda activate
compdef _custom_conda_env_list 'conda activate'

# Created by `pipx` on 2026-04-06 21:41:16
export PATH="$PATH:/Users/tonyavis/.local/bin"






