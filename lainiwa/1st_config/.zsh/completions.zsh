
# https://github.com/zulu-zsh/zulu/blob/master/src/commands/init.zsh
# not all options (see git [TAB])

# additional completions
compdef _gnu_generic tr lsb_release

# Suggestions descriptions.
builtin zstyle ':completion:*:corrections'  format ' %F{green}-- %d (errors: %e) --%f'
builtin zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
builtin zstyle ':completion:*:messages'     format ' %F{purple} -- %d --%f'
builtin zstyle ':completion:*:warnings'     format ' %F{red}-- no matches found --%f'
builtin zstyle ':completion:*'              format ' %F{yellow}-- %d --%f'

# https://www.topbug.net/blog/2017/08/08/enable-auto-completion-for-pip-in-zsh/
# eval "$(pip3 completion --zsh)"  # <-- slow af. soo:
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip3

# Select completions with arrows
zstyle ':completion:*' menu select

# Fuzzy match mistyped completions.
# builtin zstyle ':completion:*' completer _complete _match _approximate
# builtin zstyle ':completion:*:match:*' original only
# builtin zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word.
# builtin zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

