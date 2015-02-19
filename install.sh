#!/bin/sh

BASE_DIR=~
TARGET_DIR=$BASE_DIR

# Backup existing configuration.
BACKUP_DIR=backup.`date +%F-%R`
mkdir -p $BACKUP_DIR
BASE_ZSHRC=$BASE_DIR/.zshrc
BASE_ZSHPATH=$BASE_DIR/.zshpath
BASE_ZPREZTORC=$BASE_DIR/.zpreztorc
BASE_ZSH_CONFIG=$BASE_DIR/.zprezto
echo "Backing up existing configuration to $BACKUP_DIR"
if [ -f $BASE_ZSHRC ] ; then
	cp -R $BASE_ZSHRC $BACKUP_DIR/
fi
if [ -f $BASE_ZSHPATH ] ; then
	cp -R $BASE_ZSHPATH $BACKUP_DIR/
fi
if [ -f $BASE_ZPREZTORC ] ; then
	cp -R $BASE_ZPREZTORC $BACKUP_DIR/
fi
if [ -d $BASE_ZSH_CONFIG ] ; then
	cp -R $BASE_ZSH_CONFIG $BACKUP_DIR/
fi


echo "Clearing existing config"
rm -rf $BASE_ZSHRC
rm -rf $BASE_ZSHPATH
rm -rf $BASE_ZPREZTORC
rm -rf $BASE_ZSH_CONFIG


echo "Copying new files."
ln -s `pwd`/.zshrc $BASE_DIR/.zshrc
ln -s `pwd`/.zshpath $BASE_DIR/.zshpath
ln -s `pwd`/.zpreztorc $BASE_DIR/.zpreztorc
echo "Installing zprezto."
git clone --recursive https://github.com/sorin-ionescu/prezto.git $TARGET_DIR/.zprezto
cp prompt_quiet_setup $TARGET_DIR/.zprezto/modules/prompt/functions


echo "Done."
