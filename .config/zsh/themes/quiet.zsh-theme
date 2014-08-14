# First line.
PROMPT=$'
%{$fg[white]%}%n@%m%{$reset_color%} %{$FG[215]%}%/%{$reset_color%}
%{$reset_color%}'

# Second line.
PROMPT2="%{$fg_blod[black]%}%_> %{$reset_color%}"

# Prompt on the right on the second line.
RPROMPT='[%D{%D %H:%M:%S}]'

# Every minute, reset the prompt to update the date.
TMOUT=1
TRAPALRM() {
	zle reset-prompt
}
