### Added by Zplugin's installer
source ~/.zplugin/bin/zplugin.zsh
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin installer's chunk

##### BEGIN Zplugin stuff #####
### needs: zplugin, fzf

# z
zplugin ice wait lucid
zplugin light rupa/z

# cd
zplugin ice wait lucid
zplugin light b4b4r07/enhancd
export ENHANCD_FILTER=fzf
export ENHANCD_DOT_ARG='.'

# History substring searching
zplugin ice wait lucid
zplugin light zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# History multi-word search
zplugin ice wait lucid
zplugin light zdharma/history-search-multi-word

# autosuggestions, trigger precmd hook upon load
zplugin ice wait lucid atload"_zsh_autosuggest_start"
zplugin light zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Tab completions
zplugin ice wait lucid blockf atpull'zplugin creinstall -q .'
zplugin light zsh-users/zsh-completions

# Syntax highlighting
zplugin ice wait lucid atinit"zpcompinit; zpcdreplay"
zplugin light zdharma/fast-syntax-highlighting

##### END Zplugin stuff #####

##### BEGIN zshrc generic #####
### needs: exa
###   iTerm Key Bindings: 'cmd<-' : Send a, 'cmd->' : Send e
###   mkdir $HOME/.cache/

# fzf
export FZF_DEFAULT_OPTS="--height=50% --min-height=10 --reverse --border --inline-info --select-1 --exit-0"

# History settings
setopt hist_ignore_all_dups hist_save_no_dups inc_append_history share_history
SAVEHIST=1000
HISTFILE=$HOME/.cache/.zsh_history

# Directory navigation
setopt auto_cd auto_pushd pushd_ignore_dups
alias d='dirs -v | head -10'
alias b='pushd +1 > /dev/null'
alias 1='pushd +1 > /dev/null'
alias 2='pushd +2 > /dev/null'
alias 3='pushd +3 > /dev/null'
alias 4='pushd +4 > /dev/null'
alias 5='pushd +5 > /dev/null'
alias 6='pushd +6 > /dev/null'
alias 7='pushd +7 > /dev/null'
alias 8='pushd +8 > /dev/null'
alias 9='pushd +9 > /dev/null'

# Prettier tab completion
zstyle ':completion:*' menu select

# Dvorak
setopt dvorak

# Navigating backward/forward in command
bindkey '\e\e[D' backward-word
bindkey '\e\e[C' forward-word
bindkey '^[a' beginning-of-line
bindkey '^[e' end-of-line

# "words" split by '/'
export WORDCHARS=${WORDCHARS/\/}

# Better ls
alias ls='exa'

# Path
export PATH=~/bin:$PATH
fpath=(~/bin $fpath)

# Coloring
autoload -Uz colors && colors

##### END zshrc generic #####
