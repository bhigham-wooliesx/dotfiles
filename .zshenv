#!/bin/zsh

export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
[[ -r $ZDOTDIR/.zshenv ]] && source $ZDOTDIR/.zshenv
