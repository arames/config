All the files in this repository are placed in the public domain.

Installation scripts are located in the `install` directory.

To install, run

    bash -c "$(curl --fail --silent --show-error --location https://raw.githubusercontent.com/arames/config/master/.config/install/install.sh)"

And add alias to your shell config

    alias config="/usr/bin/git --git-dir="$HOME/.config/config/" --work-tree=$HOME"
