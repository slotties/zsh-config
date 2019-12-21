#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

fpath=(~/.zsh/completion $fpath) 
autoload -U compinit
compinit

setopt COMPLETE_IN_WORD
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt NO_BEEP

MAILCHECK=0

# TODO: check if I still need this
# autoload -U colors
# colors