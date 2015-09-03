#!/bin/bash

cd $(dirname $0)
BASEDIR=$(pwd)

mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
for f in $(ls ${BASEDIR}/vim); do
  ln -s ${BASEDIR}/vim/$f ~/.vim/$(basename $f)
done
ln -s ${BASEDIR}/vimrc ~/.vimrc
vim +PluginInstall +qall

# Additional installation settings.

# YCM
cd ~/.vim/bundle/YouCompleteMe
./install.py --clang-completer


# Good reference for Go related setup:
#   http://obahua.com/setup-vim-for-go-development/
# Vim-go
vim +GoInstallBinaries +qall

# Tagbar
brew install ctags
go get -u github.com/jstemmer/gotags

