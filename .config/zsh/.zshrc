# Zephyr configuration
source $ZDOTDIR/config/zephyr.zsh

# Plugins
path_plugins=(
  romkatv/zsh-bench
)

fpath_plugins=(
  # sindresorhus/pure
  # romkatv/powerlevel10k
  zsh-users/zsh-completions
)

plugins=(
  mattmc3/zephyr/plugins/environment
  mattmc3/zephyr/plugins/homebrew
  mattmc3/zephyr/plugins/color
  mattmc3/zephyr/plugins/compstyle
  mattmc3/zephyr/plugins/completion
  mattmc3/zephyr/plugins/directory
  mattmc3/zephyr/plugins/editor
  mattmc3/zephyr/plugins/history
  mattmc3/zephyr/plugins/prompt
  mattmc3/zephyr/plugins/utility
  mattmc3/zephyr/plugins/zfunctions
  mattmc3/zephyr/plugins/macos

  ohmyzsh/ohmyzsh/plugins/git

  romkatv/zsh-defer
  # olets/zsh-abbr
  zdharma-continuum/fast-syntax-highlighting
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-history-substring-search
  Aloxaf/fzf-tab
  junegunn/fzf-git.sh
  Freed-Wu/fzf-tab-source
)

# antidote.lite
source $ZDOTDIR/lib/antidote.lite.zsh
plugin-clone $path_plugins $fpath_plugins $plugins
plugin-load --kind path $path_plugins
plugin-load --kind fpath $fpath_plugins
plugin-load $plugins

# Configuration
source $ZDOTDIR/config/aliases.zsh
source $ZDOTDIR/config/keymaps.zsh
source $ZDOTDIR/config/fzf.zsh

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(fnm env --use-on-cd --version-file-strategy=recursive --corepack-enabled --resolve-engines --shell zsh)"
