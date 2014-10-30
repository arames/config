export EDITOR='vim'
export VISUAL='vim'

# Prezto framework ========================================================={{{1
# Source Prezto. Do this before anything else.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


# General configuration ===================================================={{{1
platform='unknown'
unamestr=`uname`
if [[ $OSTYPE == linux* ]]; then
	platform='linux'
elif [[ $OSTYPE == darwin* ]]; then
	platform='macos'
fi

# Path to custom zsh helpers.
ZSH_CUSTOM=$HOME/repos/config/.config/zsh
# Path where zsh scripts will backup data when needed.
ZSH_BACKUP_DIR=$HOME/backup

# Output redirection can overwrite existing files silently.
# If NOCLOBBER is set instead, overwriting an existing file requires using `>!`.
setopt CLOBBER

# Prompt configuration ====================================================={{{1

# The prompt is set in ~.zpreztorc. The following lines require reset of the
# prompt every minute to keep the date in the prompt up-to-date.
TMOUT=60
TRAPALRM() {
	zle reset-prompt
}

# Custom functions ========================================================={{{1

# Look for function definitions in $ZSH_CUSTOM/functions/.
fpath=( $ZSH_CUSTOM/functions/ "${fpath[@]}" )
# List the functions to autoload. Use the '--help' option for details.
autoload -Uz backup_files
autoload -Uz stgb

# Other configuration ======================================================{{{1

export EDITOR='vim'

export PATH=$HOME/bin:$PATH


# Use the vim mode.
bindkey -v

bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^E" history-incremental-pattern-search-forward
bindkey "^K" up-line-or-history
bindkey "^J" down-line-or-history

# Edit the command line in the editor.
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line


alias grep='grep --color=auto --exclude=".tags" --exclude-dir=".git"'
alias -g ds='| diffstat'

if [[ "$platform" == 'linux' ]]; then
	alias pbcopy='xclip -selection clipboard'
	alias pbpaste='xclip -selection clipboard -o'
	# Borrowed from Ubuntu's default ~/.bashrc.
	alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# Use a vim server if vim provides the feature.
vim --version | grep +clientserver &> /dev/null
if [ $? -eq 0 ] ; then
	alias vim='vim --servername vimserver'
fi


# .vimrc specific options =================================================={{{1
# vim: set foldmethod=marker:
