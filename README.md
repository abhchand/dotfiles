dotfiles
===========

dotfiles and other configurations for abhchand.me servers

# Setup

```bash
export DOTFILES_PATH=$HOME/git/abhishek/dotfiles

ln -s $DOTFILES_PATH/.bashrc ~/.bashrc
ln -s $DOTFILES_PATH/.bash_profile ~/.bash_profile
ln -s $DOTFILES_PATH/.gitconfig ~/.gitconfig
ln -s $DOTFILES_PATH/.vim ~/vim
ln -s $DOTFILES_PATH/.viminfo ~/.viminfo
ln -s $DOTFILES_PATH/.vimrc ~/.vimrc

# konsole
ln -s $FOTFILES_PATH/konsole/konsolerc ~/.config/konsolerc
ln -s $DOTFILES_PATH/konsole/abhchand.profile $HOME/.local/share/konsole/abhchand.profile
ln -s $DOTFILES_PATH/konsole/Github\ Dark.colorscheme $HOME/.local/share/konsole/Github\ Dark.colorscheme
```

After sourcing `~/.bash_profile`:

```bash
setup_vim
```
