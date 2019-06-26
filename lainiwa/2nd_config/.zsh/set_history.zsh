
export HISTFILE=~/.zsh_history
export HISTSIZE=10000000
export SAVEHIST=10000000

setopt HIST_VERIFY
setopt EXTENDED_HISTORY      # save each command's beginning timestamp and the duration to the history file
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY    # this is default, but set for share_history
setopt SHARE_HISTORY         # Share history file amongst all Zsh sessions
