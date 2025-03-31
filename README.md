# Dotfiles

This repository contains my personal dotfiles - configuration files for various command line tools and applications.

## What are Dotfiles?

Dotfiles are configuration files in Unix-like systems that start with a dot (.) in their filename. These files are typically hidden and contain user-specific configurations for various applications.

## Installation

Clone this repository to your home directory:

```bash
git clone https://github.com/benhigham/dotfiles.git ~/.dotfiles
```

## Setup

### Using GNU Stow (Recommended)

[GNU Stow](https://www.gnu.org/software/stow/) is a symlink farm manager that makes it easy to manage dotfiles. It creates symlinks for you based on a clean directory structure.

1. Install Stow:

    ```bash
    # On macOS
    brew install stow

    # On Debian/Ubuntu
    sudo apt-get install stow

    # On Fedora
    sudo dnf install stow
    ```

2. Use Stow to create symlinks:

    ```bash
    cd ~/.dotfiles
    stow .
    ```

### Manual Symlinks

You can set up these dotfiles using symlinks to point from your home directory to the files in this repository:

```bash
# Example for manually linking files
ln -s ~/.dotfiles/.vimrc ~/.vimrc
```

## Contents

This repository contains configurations for:

- [Zsh](https://www.zsh.org/)
- [Git](https://git-scm.com/)
- [Vim](https://www.vim.org/) and [Neovim](https://neovim.io/)
- [WezTerm](https://wezterm.org/)
- [Bat](https://github.com/sharkdp/bat)

## Customization

Feel free to fork this repository and customize it to your liking. The configurations are meant to be personalized!

## License

This project is licensed under the MIT License - see [LICENSE.md](LICENSE.md) for details.
