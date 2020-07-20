#!/bin/bash

error() {
	echo -e "${CRED}ERROR: $*${CNC}" >&2
	exit 1
}

safe() {
	echo -e "${CGREEN}$@${CNC}"
	"$@" || error "FAILED command:\n$*";
}

echo "Installing the plugin manager (vim-plug)."
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Installing plugins."
safe nvim -c PlugInstall -c :qa

echo "Done."
