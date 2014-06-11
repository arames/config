platform='unknown'
unamestr=`uname`
if [[ $OSTYPE == linux* ]]; then
	platform='linux'
elif [[ $OSTYPE == darwin* ]]; then
	platform='macos'
fi


# Path to the oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Path to custom zsh configuration files.
export ZSH_CUSTOM=$HOME/repos/config/.config/zsh
ZSH_THEME="quiet"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

if [ -d $ZSH ] ; then
	source $ZSH/oh-my-zsh.sh
fi

export EDITOR='vim'

export PATH="/home/aleram01/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
export PATH=$HOME/bin:$PATH


# Use the vim mode.
bindkey -v

# Quick shortcuts to access the history.
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^K" up-line-or-history
bindkey "^J" down-line-or-history
# Edit the command line in the editor.
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line


source $ZSH_CUSTOM/aliases.zsh
