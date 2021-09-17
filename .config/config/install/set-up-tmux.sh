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
safe git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Done."
