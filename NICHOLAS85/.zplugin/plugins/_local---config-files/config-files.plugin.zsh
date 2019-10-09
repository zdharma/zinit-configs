#Let Atom highlight this: -*- shell-script -*-

# According to the Zsh Plugin Standard:
# http://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Then ${0:h} to get plugin's directory

# Autoload personal functions
fpath=("${0:h}/functions" "${fpath[@]}")
autoload -Uz _zpcompinit_fast auto-ls-colorls auto-ls-modecheck dotscheck history-stat

#########################
#       Variables       #
#########################

HISTFILE="${HOME}/.histfile"

ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50

HISTORY_SUBSTRING_SEARCH_FUZZY=set

colorlscommand=(lsd --group-dirs first)
colorlsgitcommand=(colorls --sd --gs -A)

AUTO_LS_COMMANDS=(colorls)
#AUTO_LS_COMMANDSBAT=(ls)
AUTO_LS_NEWLINE=false

EDITOR=kate

forgit_ignore="/dev/null"

WD_CONFIG="${ZPFX}/warprc"

rm_opts=(-I -v)

# Directory checked for locally built projects (plugin updatelocal)
UPDATELOCAL_GITDIR="${HOME}/github/Built"

# Strings to ignore when using dotscheck, escape and single quote stuff that could be wild cards (../)
dotsvar=( gtkrc-2.0 kwinrulesrc '\.\./' '\.config/gtk-3\.0/settings\.ini' )

# Export variables when connected via SSH
if [[ -n $SSH_CONNECTION ]]; then
    export DISPLAY=:0
    colorlscommand=(lsd --group-dirs first --icon never)
    alias ls="lsd --group-dirs=first --icon=never"
else
    alias ls='lsd --group-dirs=first'
fi

# Used to programatically disable plugins when opening the terminal view in dolphin 
if [[ $MYPROMPT = dolphin ]]; then
    isdolphin=true
    # Aesthetic function for Dolphin, clear -x if cd while in Dolphin
    alias cd='clear -x; cd'
else
    isdolphin=false
fi

#########################
#       Aliases         #
#########################

# Allows leaving from deleted directories
alias ..='command .. 2>/dev/null || cd $(dirname $PWD)'

# Access zsh config files
alias zshconf="${=EDITOR} ${HOME}/.zshrc ${0:h}/config-files.plugin.zsh ${0:h}/themes/\${MYPROMPT} &!"

alias zshconfatom="atom ${HOME}/.zshrc ${0:h}/config-files.plugin.zsh ${0:h}/themes/\${MYPROMPT} &!"

# dot file management
alias dots=' /usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'
#           ^Space added to remove this command from history

alias g='git'
alias open='xdg-open'
# allow sudo to expand aliases as well as run anything in $PATH
alias sudo='sudo env PATH="$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"  '
alias gencomp='echo "Use gcomp"'
alias -- -='cd -'
alias atom='atom-beta --disable-gpu'
alias apm='apm-beta'

unalias zplg

#########################
#         Other         #
#########################

bindkey -e                  # EMACS bindings
setopt append_history       # Allow multiple terminal sessions to all append to one zsh command history
setopt hist_ignore_all_dups # delete old recorded entry if new entry is a duplicate.
setopt no_beep              # don't beep on error
setopt auto_cd              # If you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt multios              # perform implicit tees or cats when multiple redirections are attempted
setopt prompt_subst         # enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt interactive_comments # Allow comments even in interactive shells (especially for Muness)
setopt pushd_ignore_dups    # don't push multiple copies of the same directory onto the directory stack
setopt auto_pushd           # make cd push the old directory onto the directory stack
setopt pushdminus           # swapped the meaning of cd +1 and cd -1; we want them to mean the opposite of what they mean
setopt correct_all          # autocorrect commands

# Fuzzy matching of completions for when you mistype them:
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

# Pretty completions
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*' rehash true

bindkey '^[[1;5C' forward-word   # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word  # [Ctrl-LeftArrow]  - move backward one word
