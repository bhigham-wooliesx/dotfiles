local wezterm = require('wezterm')

local vars = {}

vars.editor = 'nvim'
vars.projects_dir = wezterm.home_dir .. '/Projects'
vars.dotfiles_dir = wezterm.home_dir .. '/.dotfiles'

return vars
