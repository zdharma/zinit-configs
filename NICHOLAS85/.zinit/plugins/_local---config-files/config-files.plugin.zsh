#Let Atom highlight this: -*- shell-script -*-

# According to the Zsh Plugin Standard:
# http://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Then ${0:h} to get plugin's directory

# Autoload personal functions
fpath=("${0:h}/functions" "${fpath[@]}")
autoload -Uz $fpath[1]/*(.:t)

! $isdolphin && add-zsh-hook chpwd chpwd_ls

#########################
#       Variables       #
#########################

pchf="${0:h}/patches"
thmf="${0:h}/themes"
GENCOMPL_FPATH="${0:h}/completions"
WD_CONFIG="${ZPFX}/warprc"
ZSHZ_DATA="${ZPFX}/z"
AUTOENV_AUTH_FILE="${ZPFX}/autoenv_auth"
export CUSTOMIZEPKG_CONFIG="${HOME}/.config/customizepkg"

# Directory checked for locally built projects (plugin NICHOLAS85/updatelocal)
UPDATELOCAL_GITDIR="${HOME}/github/built"

ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HISTORY_IGNORE="?(#c100,)"
ZSH_AUTOSUGGEST_MANUAL_REBIND=set
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
FAST_ALIAS_TIPS_PREFIX="» $(tput setaf 6)"
FAST_ALIAS_TIPS_SUFFIX="$(tput sgr0) «"
HISTORY_SUBSTRING_SEARCH_FUZZY=set

export OPENCV_LOG_LEVEL=ERROR # Hide nonimportant errors for howdy
export rm_opts=(-I -v)
export EDITOR=micro
export SYSTEMD_EDITOR=${EDITOR}
export GIT_DISCOVERY_ACROSS_FILESYSTEM=true # etckeeper on bedrock
FZF_DEFAULT_OPTS="
--border
--height 80%
--extended
--ansi
--reverse
--cycle
--bind ctrl-s:toggle-sort
--bind 'alt-e:execute($EDITOR {} >/dev/tty </dev/tty)'
--preview \"(bat --color=always {} || ls -l --color=always {}) 2>/dev/null | head -200\"
--preview-window right:60%
"
FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git 2>/dev/null"

AUTO_LS_COMMANDS="colorls"
AUTO_LS_NEWLINE=false

FZ_HISTORY_CD_CMD=zshz
ZSHZ_CMD="" # Don't set the alias, fz will cover that
ZSHZ_UNCOMMON=1
forgit_ignore="/dev/null" #replaced gi with local git-ignore plugin

# Strings to ignore when using dotscheck, escape stuff that could be wild cards (../)
dotsvar=( gtkrc-2.0 kwinrulesrc '\.\./' \.config/gtk-3\.0/settings\.ini )

# Export variables when connected via SSH
if [[ -n $SSH_CONNECTION ]]; then
    export DISPLAY=:0
    alias ls="lsd --group-dirs=first --icon=never"
else
    alias ls='lsd --group-dirs=first'
fi

# Set variables if on ac mode
if [[ $(cat /run/tlp/last_pwr) = 0 ]]; then
    alias micro="micro -fastdirty false"
fi

#########################
#       Aliases         #
#########################

# Access zsh config files
alias zshconf="(){ setopt extendedglob local_options; kate ${HOME}/.zshrc ${0:h}/config-files.plugin.zsh ${0:h}/themes/\${MYPROMPT}-*~*.zwc }"
alias zshconfatom="(){ setopt extendedglob local_options; atom ${HOME}/.zshrc ${0:h}/config-files.plugin.zsh ${0:h}/themes/\${MYPROMPT}-*~*.zwc &! }"

alias t='tail -f'
alias g='git'
alias open='xdg-open'
alias atom='atom-beta --disable-gpu'
alias apm='apm-beta'
alias ..='cd .. 2>/dev/null || cd "$(dirname $PWD)"' # Allows leaving from deleted directories
# Aesthetic function for Dolphin, clear -x if cd while in Dolphin
$isdolphin && alias cd='clear -x; cd'

# dot file management
alias dots='DOTBARE_DIR="$HOME/.dots" DOTBARE_TREE="$HOME" DOTBARE_BACKUP="${ZPFX:-${XDG_DATA_HOME:-$HOME/.local/share}}/dotbare" dotbare'
export DOTBARE_FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"

(( ${+commands[brl]} )) && {
(){ local stratum strata=( /bedrock/run/enabled_strata/* )
for stratum in ${strata:t}; do
hash -d "${stratum}"="/bedrock/strata/${stratum}"
alias "${stratum}"="strat ${stratum}"
alias "r${stratum}"="strat -r ${stratum}"
[[ -d "/bedrock/strata/${stratum}/etc/.git" ]] && \
alias "${stratum:0:1}edots"="command sudo strat -r ${stratum} git --git-dir=/etc/.git --work-tree=/etc"
done }
alias bedots='command sudo DOTBARE_FZF_DEFAULT_OPTS="$DOTBARE_FZF_DEFAULT_OPTS" DOTBARE_DIR="/bedrock/.git" DOTBARE_TREE="/bedrock" DOTBARE_BACKUP="${ZPFX:-${XDG_DATA_HOME:-$HOME/.local/share}}/bdotbare" dotbare'
}

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
zstyle ':completion:*' use-cache true
zstyle ':completion:*' rehash true

bindkey '^[[1;5C' forward-word   # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word  # [Ctrl-LeftArrow]  - move backward one word
bindkey -s '^[[5~' ''            # Do nothing on pageup and pagedown. Better than printing '~'.
bindkey -s '^[[6~' ''
bindkey '^[[3;5~' kill-word      # ctrl+del   delete next word
