# dotfiles

My macOS setup for zsh, Git, Homebrew, PHP/Laravel, and other development tools.

## Install

```sh
git clone git@github.com:rcscatapang/dotfiles.git ~/Workspace/code/dotfiles
~/Workspace/code/dotfiles/bin/install
```

Before creating symlinks, the installer moves existing dotfiles to
`~/.dotfiles-backup/<timestamp>/`.

## Structure

- `bin/install` installs packages and links the dotfiles.
- `config/Brewfile` lists Homebrew packages and apps.
- `home/` contains shell and Git configuration.

## Machine-specific settings

Keep settings that should not be committed in `~/.zshrc.local` for the shell or
`~/.gitconfig.local` for Git.
