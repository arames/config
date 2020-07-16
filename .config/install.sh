#!/bin/bash

CONFIG_REPO_PATH="$HOME/.config/config"

git clone --bare git@github.com:arames/config.git $CONFIG_REPO_PATH
function config {
  /usr/bin/git --git-dir="$CONFIG_REPO_PATH/" --work-tree=$HOME $@
}

DATE=`date +%F_%R`
export BACKUP_DIR=$HOME/.config/backup/$DATE
mkdir -p "$BACKUP_DIR"

config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
else
  echo "Backing up pre-existing dot files to $BACKUP_DIR.";
  config checkout 2>&1 | egrep "^\s+" | awk {'print $1'} | xargs -I{} sh -c 'mkdir -p $(dirname "$BACKUP_DIR"/{}); mv "$HOME/{}" "$BACKUP_DIR"/{};'
fi;
config checkout
config config status.showUntrackedFiles no
