#!/bin/bash

error() {
	echo -e "${CRED}ERROR: $*${CNC}" >&2
	exit 1
}

safe() {
	echo -e "${CGREEN}$@${CNC}"
	"$@" || error "FAILED command:\n$*";
}

echo "Installing the plugin manager (tpm)."
if [ -d ~/.tmux/plugins/tpm ]; then
	echo "tpm already installed, updating..."
	safe git -C ~/.tmux/plugins/tpm pull
else
	safe git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "Installing tmux plugins..."
safe ~/.tmux/plugins/tpm/bin/install_plugins


echo "Done."
