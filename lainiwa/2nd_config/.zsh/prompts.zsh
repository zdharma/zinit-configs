
setopt PROMPT_SUBST # allow expansion in prompts

# https://github.com/agkozak/agkozak-zsh-theme
_is_ssh() {
    [[ -n "${SSH_CONNECTION-}${SSH_CLIENT-}${SSH_TTY-}" ]]
}
_is_ssh && host='%F{red}@%F{yellow}%m' || host=''

export PS1="%B%F{yellow}%n${host}%F{red}: %F{green}%~ %F{red}%#%f%b "
export PS2="%_> "
export RPS1="%B%F{yellow}%(?..(%?%))%f%b"

unset -f _is_ssh
unset -v host
