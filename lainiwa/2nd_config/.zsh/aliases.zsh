
# Colorize and humanify `ls`
if [[ "$(uname -s)" == "FreeBSD" ]]; then
    alias ls='ls -h -G'
else
    alias ls='ls -h --color=auto'
fi
alias ll='ls -l'
alias la='ls -A'
alias lal='ls -Al'

# Colorize `grep`s
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias mkdir='mkdir -pv'
alias tree='tree -C'
alias U='unbuffer '

alias -g H="| sed 11q"  # (:
alias -g T="| tail"

alias -g G="| grep"
alias -g S="| sed"

alias -g L="| less"
alias -g LR="| less -R"  # less with colors support

alias -g C='| column -t'

alias -g NE="2> /dev/null"
alias -g NUL="&> /dev/null"

# Set grc alias for available commands.
[[ -f /etc/grc.conf ]]           && grc_conf='/etc/grc.conf'
[[ -f /usr/local/etc/grc.conf ]] && grc_conf='/usr/local/etc/grc.conf'
if [ ! -z "$grc_conf" ]; then
    for cmd in $(grep '^# ' "$grc_conf" | cut -f 2 -d ' '); do
        if (( $+commands[$cmd] )) &&  [ "$cmd" != "ls" ]; then
            alias $cmd="grc --colour=auto $cmd"
        fi
    done
fi


# Create directory and cd to it
mkcd() { mkdir -- "$1" && cd -P -- "$1" ; }


# Alias for altering some symbol with newline
# Example: echo $PATH TRN :
__rt__() { tr -- "$2" "$1" ; }
alias -g TRN='| __rt__ "\n" '


# Remove colors
alias -g NOC='| sed -r "s/\x1B\[[0-9;]*[JKmsu]//g"'


# npm-exec binary_name, to run localy installed nodejs binary
alias npm-exec='PATH=$(npm bin):$PATH'
