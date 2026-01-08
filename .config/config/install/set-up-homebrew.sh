#!env bash

# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew install \
basedpyright \
cmake \
ctags \
fzf \
git \
htop \
luarocks \
ninja \
npm \
nvim \
ripgrep \
stgit \
tmux \
tree-sitter-cli \
zsh \

# Install the hack nerd font to support unicode characters, e.g. in nvim.
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font


# Install and symlink a few LLVM/Clang utilties.
#brew install llvm
#llvm=$(ls -d /usr/local/Cellar/llvm/* | head -n1)
#llvm_bins="$llvm/bin"
#for bin in clangd clang-format git-clang-format; do
#  ln -s "$llvm_bins/$bin" /usr/local/bin/$bin
#done

## Install yabai.
## https://github.com/koekeishiya/yabai
#brew install koekeishiya/formulae/yabai
#sudo yabai --install-sa
#brew services start yabai
#killall Dock
#
## Install skhd.
## https://github.com/koekeishiya/skhd
#brew install koekeishiya/formulae/skhd
#brew services start skhd
