### Added by Zplugin's installer
source ~/.zplugin/bin/zplugin.zsh
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin installer's chunk

##### BEGIN Zplugin stuff #####
### needs: zplugin, fzf

# z
zplugin ice wait blockf lucid
zplugin light rupa/z

# z tab completion
zplugin ice wait lucid
zplugin light changyuheng/fz

# z / fzf (ctrl-g)
zplugin ice wait lucid
zplugin light andrewferrier/fzf-z

# cd
zplugin ice wait lucid
zplugin light changyuheng/zsh-interactive-cd

# Don't bind these keys until ready
bindkey -r '^[[A'
bindkey -r '^[[B'
function __bind_history_keys() {
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
}
# History substring searching
zplugin ice wait lucid atload'__bind_history_keys'
zplugin light zsh-users/zsh-history-substring-search

# autosuggestions, trigger precmd hook upon load
zplugin ice wait lucid atload'_zsh_autosuggest_start'
zplugin light zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=10

# Tab completions
zplugin ice wait lucid blockf atpull'zplugin creinstall -q .'
zplugin light zsh-users/zsh-completions

# Syntax highlighting
zplugin ice wait lucid atinit'zpcompinit; zpcdreplay'
zplugin light zdharma/fast-syntax-highlighting

##### END Zplugin stuff #####
