
#################################################################
# INSTALL `zplugin` AND LOAD IT
#

# Install `zplugin` if not installed
if [ ! -d "${HOME}/.zplugin" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
fi

# Load `zplugin`
source "${HOME}/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin


#################################################################
# FUNCTIONS TO MAKE CONFIGURATION LESS VERBOSE
#

turbo0()   { zplugin ice wait"0a" lucid             "${@}"; }
turbo1()   { zplugin ice wait"0b" lucid             "${@}"; }
turbo2()   { zplugin ice wait"0c" lucid             "${@}"; }
zcommand() { zplugin ice wait"0b" lucid as"command" "${@}"; }
zload()    { zplugin load                           "${@}"; }
zsnippet() { zplugin snippet                        "${@}"; }


#################################################################
# PROMPT SETTINGS
#
# This settings are applied immidiately (because we need to show
# prompt as fast as possible), so the plugins are being loaded
# eagerly.
#

# Print python virtual environment name in prompt
zload tonyseek/oh-my-zsh-virtualenv-prompt
export PS1='%B%F{green}$(virtualenv_prompt_info)'${PS1}

# Print command exit code as a human-readable string
zload bric3/nice-exit-code
export RPS1='%B%F{red}$(nice_exit_code)%f%b'

# Add execution time to right prompt
zload sindresorhus/pretty-time-zsh
zload popstas/zsh-command-time
export ZSH_COMMAND_TIME_MIN_SECONDS=1
export ZSH_COMMAND_TIME_MSG=''
export RPS1=${RPS1}' %B%F{green}$([[ -n ${ZSH_COMMAND_TIME} ]] && pretty-time ${ZSH_COMMAND_TIME})%f%b'


#################################################################
# FUZZY SEARCH AND MOVEMENT
#
# Install a fuzzy finder (fzf/fzy) and necessary completions
# and key bindings.
#

# Install `fzf` bynary and tmux helper script
zcommand from"gh-r";         zload junegunn/fzf-bin
zcommand pick"bin/fzf-tmux"; zload junegunn/fzf
# Create and bind multiple widgets using fzf
turbo0 multisrc"shell/{completion,key-bindings}.zsh" \
        id-as"junegunn/fzf_completions" pick"/dev/null"
    zload junegunn/fzf

# Fuzzy movement and directory choosing
turbo1; zload rupa/z               # autojump command
turbo0; zload andrewferrier/fzf-z  # Pick from most frecent folders with `Ctrl+g`
turbo0; zload changyuheng/fz       # lets z+[Tab] and zz+[Tab]

# Like `z` command, but opens a file in vim based on frecency
zcommand pick"v"; zload rupa/v

# Install `fzy` fuzzy finder, if not yet present in the system
# Also install helper scripts for tmux and dwtm
turbo0 as"command" if'[[ -z "$commands[fzy]" ]]' \
       make"!PREFIX=$ZPFX install" atclone"cp contrib/fzy-* $ZPFX/bin/" pick"$ZPFX/bin/fzy*"
    zload jhawthorn/fzy
# Install fzy-using widgets
turbo0 silent; zload aperezdc/zsh-fzy
bindkey '\ec' fzy-cd-widget
bindkey '^T'  fzy-file-widget

# Fuzzy search by `Ctrl+P` a file and open in `$EDITOR`
# Implements it's own fuzzy search
turbo0; zload mafredri/zsh-async
turbo0; zload seletskiy/zsh-fuzzy-search-and-edit
bindkey '^P' fuzzy-search-and-edit
export EDITOR=${EDITOR:-vim}


#################################################################
# INSTALL NON-PLUGIN COMMANDS
#

# Install `ffsend` (a Firefox Send client) statically-linked binary
zcommand from"gh-r" bpick"*-static" mv"* -> ffsend";
    zload timvisee/ffsend
# Install `ffsend` completions
turbo0 as'completion' id-as'timvisee/ffsend_completions'
    zsnippet 'https://raw.githubusercontent.com/timvisee/ffsend/master/contrib/completions/_ffsend'

# Install `cloc` (code summary) binary if not already installed via package manager
zcommand if'[[ -z "$commands[cloc]" ]]' from"gh-r" bpick"*pl" mv"cloc-* -> cloc";
    zload AlDanial/cloc

# Install timelapse screen recorder
zcommand from"gh-r" mv'tl-* -> tl' if'[[ -n $DISPLAY ]]'
    zload ryanmjacobs/tl


#################################################################
# INSTALL `k` COMMAND AND GENERATE COMPLITIONS
#
turbo0; zload RobSis/zsh-completion-generator
turbo1 atclone"gencomp k; ZPLGM[COMPINIT_OPTS]='-i' zpcompinit" atpull'%atclone'
    zload supercrabtree/k
alias l='k -h'


#################################################################
# OTHER PLUGINS
#

# Add `git dsf` command to git
zcommand pick"bin/git-dsf";            zload zdharma/zsh-diff-so-fancy

# Add command-line online translator
turbo1 if'[[ -n "$commands[gawk]" ]]'; zload soimort/translate-shell

# `...` ==> `../..`
# turbo2 pick"manydots-magic";           zload knu/zsh-manydots-magic

# Toggles "sudo" before the current/previous command by pressing ESC-ESC.
turbo1; zload hcgraf/zsh-sudo

# Run `fg` command to return to foregrounded (Ctrl+Z'd) vim
turbo1; zload mdumitru/fancy-ctrl-z

# Install gitcd function to clone git repository and cd into it
turbo1; zload lainiwa/gitcd
export GITCD_TRIM=1
export GITCD_HOME=${HOME}/tmp


#################################################################
# INSTALL/SOURCE LOCAL STUFF
#

# Install completions for `my` script and for python-gist
# (use `-f` flag to force completion installation)
zplugin ice as"completion" if"[ -f '${HOME}/.zsh/completions/_my' ]" id-as"my";
    zsnippet "${HOME}/.zsh/completions/_my"

turbo0 as"completion" if"[ -f '${HOME}/.local/share/gist/gist.zsh' ]" id-as"gist" mv"gist.zsh -> _gist";
    zsnippet "${HOME}/.local/share/gist/gist.zsh"


#################################################################
# IMPORTANT PLUGINS
#

# Additional completion definitions
turbo0 blockf
zload zsh-users/zsh-completions

# History search by `Ctrl+R`
turbo1; zload zdharma/history-search-multi-word

# Syntax highlighting
# (compinit without `-i` spawns warning on `sudo -s`)
turbo0 atinit"ZPLGM[COMPINIT_OPTS]='-i' zpcompinit; zpcdreplay"
    zload zdharma/fast-syntax-highlighting

# Autosuggestions
# Note: should go _after_ syntax highlighting plugin
turbo0 atload"_zsh_autosuggest_start"; zload zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1


#################################################################
# REMOVE TEMPORARY FUNCTIONS
#
unset -f turbo0
unset -f zload
unset -f zsnippet
