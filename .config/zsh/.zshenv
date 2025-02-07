export ZDOTDIR=${ZDOTDIR:-$HOME/.config/zsh}

# XDG
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

# Basics
export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"

export LESSOPEN="| LESSQUIET=1 /opt/homebrew/bin/lesspipe.sh %s"
export LESSCOLORIZER='bat --theme="Catppuccin Mocha"'

# Projects
export PROJECT_HOME="$HOME/Projects"

# Disable telemetry
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export NEXT_TELEMETRY_DISABLED=1
export STORYBOOK_DISABLE_TELEMETRY=1
