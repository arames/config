# General configuration ===================================================={{{1
platform='unknown'
unamestr=`uname`
if [[ $OSTYPE == linux* ]]; then
	platform='linux'
elif [[ $OSTYPE == darwin* ]]; then
	platform='macos'
fi

# Path to custom zsh helpers.
ZSH_CUSTOM=$HOME/.config/config/.config/zsh
# Path where zsh scripts will backup data when needed.
ZSH_BACKUP_DIR=/backup

# Output redirection can overwrite existing files silently.
# If NOCLOBBER is set instead, overwriting an existing file requires using `>!`.
setopt CLOBBER

# Prompt configuration ====================================================={{{1

PROMPT='%n@%m:%F{yellow}%~%f %# '

# History configuration ===================================================={{{1

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# See `man zshoptions` for details.
setopt append_history
setopt hist_ignore_all_dups
setopt hist_verify

# Completion configuration ================================================={{{1

autoload -U compinit
compinit

# Insert a common prefix before using the menu.
setopt list_ambiguous
# Don't automatically select the first completion entry.
unsetopt menu_complete

# Custom functions ========================================================={{{1

# Look for function definitions in $ZSH_CUSTOM/functions/.
fpath=( $ZSH_CUSTOM/functions/ "${fpath[@]}" )
# List the functions to autoload. Use the '--help' option for details.
autoload -Uz backup_files
autoload -Uz stgb
autoload -Uz stgpatches

# Aliases =================================================================={{{1

alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias grep='grep --color=auto --exclude=".tags" --exclude-dir=".git"'
alias -g ds='| diffstat'
alias -g v-='| vim -'

if [[ "$platform" == 'linux' ]]; then
	alias pbcopy='xclip -selection clipboard'
	alias pbpaste='xclip -selection clipboard -o'
	# Borrowed from Ubuntu's default ~/.bashrc.
	alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# Stop using this with neovim.
## Use a vim server if vim provides the feature.
#vim --version | grep +clientserver &> /dev/null
#if [ $? -eq 0 ] ; then
#	alias vim='vim --servername vimserver'
#fi

# Command line editing ====================================================={{{1

export EDITOR='vim'
export VISUAL='vim'

if [[ -s "$HOME/.zshpath" ]]; then
  source "$HOME/.zshpath"
fi

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

# Other configuration ======================================================{{{1

if [[ $TERM == "xterm" ]]; then
	TERM="xterm-256color"
fi

# .vimrc specific options =================================================={{{1
# vim: set foldmethod=marker:
