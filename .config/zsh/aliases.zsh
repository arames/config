alias grep='grep --color=auto --exclude=".tags" --exclude-dir=".git"'
alias ds='diffstat'

if [[ "$platform" == 'linux' ]]; then
	alias pbcopy='xclip -selection clipboard'
	alias pbpaste='xclip -selection clipboard -o'
fi


# Use a vim server if vim provides the feature.
vim --version | grep +clientserver &> /dev/null
if [ $? -eq 0 ] ; then
	alias vim='vim --servername vimserver'
fi
