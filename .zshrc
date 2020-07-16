# Local configuration at start ============================================={{{1

# Allow sourcing a local configuration first.
ZSH_LOCAL_CONFIG_AT_START=${ZSH_LOCAL_CONFIG_AT_START:=$HOME/.config/zsh/local.at_start}

if [ -r $ZSH_LOCAL_CONFIG_AT_START ]; then
	source "$ZSH_LOCAL_CONFIG_AT_START"
fi



# General configuration ===================================================={{{1

platform='unknown'
if [[ $OSTYPE == linux* ]]; then
	platform='linux'
elif [[ $OSTYPE == darwin* ]]; then
	platform='macos'
	# Fix zsh functions path to point to brew completions first.
	fpath=( /usr/local/share/zsh/functions "${fpath[@]}" )
fi

# Path to custom zsh helpers.
ZSH_CUSTOM=${ZSH_CUSTOM:=$HOME/.config/zsh}

# Path where zsh scripts will backup data when needed.
ZSH_BACKUP_DIR=${ZSH_BACKUP_DIR:=$HOME/backup}


setopt no_beep              # Don't beep!
setopt interactive_comments # Allow comments in interactive shells.
setopt extended_glob        # Better pattern matching.

# Output redirection can overwrite existing files silently.
setopt clobber



# Prompt configuration ====================================================={{{1

PROMPT=$'%T %n@%m:%F{yellow}%~%f\n%# '
# Automatically refresh the prompt every 10 seconds to update the clock.
TMOUT=10
TRAPALRM() { zle reset-prompt }



# History configuration ===================================================={{{1

setopt append_history         # Zsh sessions append to the history file instead of rewriting it.
setopt extended_history       # Save command's timestamps.
setopt inc_append_history     # Don't wait until the shell exits to add commands to the history.
setopt hist_expire_dups_first # When trimming history, remove oldest duplicates first.
setopt hist_ignore_all_dups   # Don't duplicate commands in the history.
setopt hist_find_no_dups      # Skip duplicates when searching through history.
setopt hist_reduce_blanks     # Remove superfluous blanks.
setopt hist_verify            # When using history expansion, expand instead of executing immediately.

HISTFILE=$ZSH_CUSTOM/history
HISTSIZE=1000000
SAVEHIST=1000000



# Command line editing ====================================================={{{1

export EDITOR='nvim'
export GIT_EDITOR='nvim'
export VISUAL='nvim'

bindkey -v # Use the vim editing mode.

#bindkey "^W" backward-kill-word
#bindkey "^H" backward-delete-char
#bindkey "^U" backward-kill-line
##bindkey "^?" backward-delete-char

bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^E" history-incremental-pattern-search-forward

# For my use-case, using Ctrl-P and Ctrl-N on an empty line achieves the same
# result. This way I can use Ctrl-K and Ctrl-J with tmux/vim and the
# vim-tmux-navigator plugin.
#bindkey "^K" up-line-or-history
#bindkey "^J" down-line-or-history

# Edit the command line in the editor.
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line



# Aliases =================================================================={{{1

alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias vim='nvim'
alias -g ds='| diffstat'
alias -g v-='| vim -'

if [[ "$platform" == 'linux' ]]; then
	alias pbcopy='xclip -selection clipboard'
	alias pbpaste='xclip -selection clipboard -o'
	# Borrowed from Ubuntu's default ~/.bashrc.
	alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

alias config="/usr/bin/git --git-dir="$HOME/.config/config/" --work-tree=$HOME"



# Completion configuration ================================================={{{1

source $ZSH_CUSTOM/completion.zsh



# Custom functions ========================================================={{{1

# Look for function definitions in $ZSH_CUSTOM/functions/.
fpath=( $ZSH_CUSTOM/functions/ "${fpath[@]}" )
# List the functions to autoload. Use the '--help' option for details.
autoload -Uz backup_files
autoload -Uz stgb
autoload -Uz stgpatches



# Misc configuration ======================================================={{{1

export XDG_CONFIG_HOME=~/.config

export PATH=$PATH:~/bin

export GREP_OPTIONS="--color=auto --exclude=.tags --exclude-dir=.git"

# rust cargo location
export CARGO_HOME=$XDG_CONFIG_HOME/cargo
export PATH=$PATH:$CARGO_HOME/bin



# Local configuration at end ==============================================={{{1

# Allow sourcing a local after the default configuration. This is useful when
# the default configuration needs to be fixed up.
# For example on macOS, to fix delete key issues, I use:
#     # Fix delete key in standard insert mode.
#     bindkey "^[[3~" delete-char
#     # Fix delete key in zsh vi command mode.
#     bindkey -M vicmd "^[[3~" delete-char
ZSH_LOCAL_CONFIG_AT_END=${ZSH_LOCAL_CONFIG_AT_END:=$HOME/.config/zsh/local.at_end}
if [ -r $ZSH_LOCAL_CONFIG_AT_END ]; then
	source "$ZSH_LOCAL_CONFIG_AT_END"
fi



## .vimrc specific options =================================================={{{1
## vim: set foldmethod=marker:
