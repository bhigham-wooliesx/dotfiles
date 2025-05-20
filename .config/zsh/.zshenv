export ZDOTDIR=${ZDOTDIR:-$HOME/.config/zsh}

# XDG
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

# Basics
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

export LESSOPEN="| LESSQUIET=1 /opt/homebrew/bin/lesspipe.sh %s"
export LESSCOLORIZER='bat'

export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"

# Projects
export PROJECT_HOME="$HOME/Projects"

# Disable telemetry
export DO_NOT_TRACK=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export NEXT_TELEMETRY_DISABLED=1
export STORYBOOK_DISABLE_TELEMETRY=1
export TURBO_TELEMETRY_DISABLED=1

[[ -r $ZDOTDIR/.zshenv.local ]] && source $ZDOTDIR/.zshenv.local
