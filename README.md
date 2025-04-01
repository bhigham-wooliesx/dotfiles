# dotfiles

This repository contains my personal dotfiles - configuration files for various tools and applications.

## Installation

Set `zsh` as your login shell:

```bash
chsh -s $(which zsh)
```

Clone this repository to your home directory:

```bash
git clone https://github.com/benhigham/dotfiles.git ~/.dotfiles
```

## Usage

### GNU Stow (Recommended)

[GNU Stow](https://www.gnu.org/software/stow/) is a symlink farm manager that simplifies dotfile management by automatically creating symlinks based on directory structure.

1. Install Stow:

    ```bash
    # On macOS
    brew install stow

    # On Debian/Ubuntu
    sudo apt-get install stow

    # On Fedora
    sudo dnf install stow
    ```

2. Create target directories (optional):

    ```bash
    mkdir -p ~/.config
    ```

    This ensures stow will only create symlinks within existing directories rather than symlinking entire directories.

3. Deploy the dotfiles:

    ```bash
    cd ~/.dotfiles
    stow .
    ```

    This will create symlinks from your home directory to the corresponding files in the ~/.dotfiles repository, preserving the same directory structure.

    To stow specific configurations only:

    ```bash
    # Example: only set up `nvim` configuration
    stow .config/nvim

    # Example: set up multiple specific configs
    stow .vimrc .config/wezterm .config/git
    ```

### Manual Symlinks

You can set up these dotfiles using symlinks to point from your home directory to the files in this repository:

```bash
# Example for manually linking files
ln -s ~/.dotfiles/.vimrc ~/.vimrc
```

## Requirements

This repository contains configurations for:

- [Zsh](https://www.zsh.org/)
- [Git](https://git-scm.com/)
- [Vim](https://www.vim.org/) and [Neovim](https://neovim.io/)
- [WezTerm](https://wezterm.org/)

Some of the other tools I have configured:

- [bat](https://github.com/sharkdp/bat)
- [Delta](https://dandavison.github.io/delta/)
- [eza](https://eza.rocks/)
- [Fast Node Manager (fnm)](https://fnm.vercel.app/)
- [fd](https://github.com/sharkdp/fd)
- [fzf](https://junegunn.github.io/fzf/)
- [Lazygit](https://github.com/jesseduffield/lazygit)
- [lesspipe](https://github.com/wofr06/lesspipe)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Starship](https://starship.rs/)
- [Zephyr](https://github.com/mattmc3/zephyr)
- [zoxide](https://github.com/ajeetdsouza/zoxide)

### Installing Required Tools

#### On macOS (using Homebrew)

Before using these dotfiles, ensure you have the necessary dependencies installed.

```bash
brew install zsh git vim neovim wezterm bat git-delta eza fnm fd fzf lazygit lesspipe starship zoxide
```

#### On Linux

Some tools require manual installation or alternative sources on Linux. Check the project links above for more detailed documentation.

## Troubleshooting

### Common Issues

- **Stow errors about existing files**: Back up and remove the existing files before stowing

  ```bash
  mv ~/.zshenv ~/.zshenv.bak
  ```

- **Missing terminal icons**: Install a [Nerd Font](https://www.nerdfonts.com/) for proper icon display

  ```bash
  # macOS
  brew install --cask font-hack-nerd-font
  ```

- **Git config conflicts**: Ensure your local Git configuration in `~/.config/git/config.local` doesn't conflict with the repository's git config

## Git Configuration

This repository includes the base Git configuration, but certain personal information like your email address should not be committed to version control.

To configure the `user` in Git:

1. Create a `config.local` file in the `~/.config/git/` directory:

   ```bash
   mkdir -p ~/.config/git
   touch ~/.config/git/config.local
   ```

2. Add your personal Git configuration to this file. For example:

   ```gitconfig
   [user]
     name = Your Name
     email = your.email@example.com
   ```

3. Git will automatically load this configuration alongside the repository's git config.

**Note:** The `~/.config/git/config.local` file is ignored by Git and should not be committed to the repository.

## Customization

Feel free to fork this repository and customize it to your liking. The configurations are meant to be personalized!

## License

This project is licensed under the [MIT License](LICENSE.md).
