#
# General
#

zstyle ':zephyr:*:*' use-xdg-basedirs 'yes'
zstyle ':zephyr:plugin:*' 'use-cache' 'yes'

#
# Completions
#

# Set the entries to ignore in static '/etc/hosts' for host completion.
zstyle ':zephyr:plugin:compstyle:*:hosts' etc-host-ignores \
  '0.0.0.0' '127.0.0.1'

# Set the preferred completion style.
zstyle ':zephyr:plugin:completion' compstyle 'zephyr'

#
# Editor
#

# Set the key mapping style to 'emacs' or 'vi'.
zstyle ':zephyr:plugin:editor' key-bindings 'vi'

# Auto convert .... to ../..
zstyle ':zephyr:plugin:editor' dot-expansion 'yes'

# Use ^z to return background processes to foreground.
zstyle ':zephyr:plugin:editor' symmetric-ctrl-z 'yes'

# Expand aliases to their actual command like Fish abbreviations.
zstyle ':zephyr:plugin:editor' glob-alias 'yes'

# Set the default (magic) command when hitting enter on an empty prompt.
zstyle ':zephyr:plugin:editor' magic-enter 'yes'
zstyle ':zephyr:plugin:editor:magic-enter' command 'ls -la .'
zstyle ':zephyr:plugin:editor:magic-enter' git-command 'git status -u .'

#
# History
#

# Set the maximum number of events stored in the internal history list.
zstyle ':zephyr:plugin:history' histsize 10000

# Set the maximum number of history events to save in the history file.
zstyle ':zephyr:plugin:history' savehist 10000

#
# Prompt
#

# Set the prompt theme to load.
# starship themes: zephyr, hydro, prezto
zstyle ':zephyr:plugin:prompt' theme starship benhigham
