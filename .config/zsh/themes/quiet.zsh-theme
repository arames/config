PROMPT=$'
%{$fg[white]%}%n@%m%{$reset_color%}|%{$fg[white]%}%D %T%{$reset_color%}| %{$FG[215]%}%/%{$reset_color%} $(git_prompt_info)$(bzr_prompt_info)
%{$reset_color%}'

PROMPT2="%{$fg_blod[black]%}%_> %{$reset_color%}"

GIT_CB="git::"
ZSH_THEME_GIT_PROMPT_PREFIX=$GIT_CB
ZSH_THEME_GIT_PROMPT_SUFFIX=
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

## Bazaar integration
bzr_prompt_info() {
	BZR_CB=`bzr nick 2> /dev/null | grep -v "ERROR" | cut -d ":" -f2 | awk -F / '{print "bzr::"$1}'`
	if [ -n "$BZR_CB" ]; then
		BZR_DIRTY=""
		[[ -n `bzr status` ]] && BZR_DIRTY="%{$fg[red]%} *%{$reset_color%}"
		echo "$ZSH_THEME_SCM_PROMPT_PREFIX$BZR_CB$BZR_DIRTY$ZSH_THEME_GIT_PROMPT_SUFFIX"
	fi
}