source $ZDOTDIR/basic.zsh
source $ZDOTDIR/tools.zsh
source $ZDOTDIR/aliases.zsh

if [[ -n `which $ZDOTDIR/local.zsh` ]]; then
  source $ZDOTDIR/local.zsh
fi
