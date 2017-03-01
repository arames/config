#!/bin/sh

BASE_DIR=~
TARGET_DIR=$BASE_DIR

# Backup existing configuration.
BACKUP_DIR=backup.`date +%F-%R`
mkdir -p $BACKUP_DIR
BASE_ZSHRC=$BASE_DIR/.zshrc
BASE_ZSHPATH=$BASE_DIR/.zshpath
echo "Backing up existing configuration to $BACKUP_DIR"
if [ -e $BASE_ZSHRC ] ; then
	mv $BASE_ZSHRC $BACKUP_DIR/
fi
if [ -e $BASE_ZSHPATH ] ; then
	mv $BASE_ZSHPATH $BACKUP_DIR/
fi

echo "Linking new files."
ln -s `pwd`/.zshrc $BASE_DIR/.zshrc
ln -s `pwd`/.zshpath $BASE_DIR/.zshpath

echo "Done."
