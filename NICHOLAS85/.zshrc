# https://github.com/NICHOLAS85/dotfiles/blob/xps_13_9365/.zshrc

# Install zplugin if not installed
if [ ! -d "${HOME}/.zplugin" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
fi

module_path+=( "/home/nicholas/.zplugin/bin/zmodules/Src" )
zmodload zdharma/zplugin

### Added by Zplugin's installer
source "${HOME}/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin's installer chunk

if [[ ! -d "$ZPFX" ]]; then
    mkdir -v $ZPFX
fi
if [[ ! -d "${ZPLGM[PLUGINS_DIR]}/_local---config-files" ]]; then
    curl https://codeload.github.com/NICHOLAS85/dotfiles/tar.gz/xps_13_9365 | \
    tar -xz --strip=3 dotfiles-xps_13_9365/.zplugin/plugins/_local---config-files
    mv _local---config-files "${ZPLGM[PLUGINS_DIR]}/"
fi

# Functions to make configuration less verbose
# z()  : Loads plugin using light mode unless otherwise specified in first argument
# zt() : First argument is a wait time and suffix eg "0a". Anything that doesn't match will be passed as if it were an ice mod. Default ices depth'1' and lucid.
# zct(): First argument determines value $MYPROMPT is checked against in load'' and unload'' ices. On load sources a config file with tracking using the first argument as it's name for easy unloading.

z()   { [ -z $2 ] && { zplugin light "${@}"; ((1)); } || zplugin "${@}"; }
zt()  { zplugin ice depth'1' lucid ${1/#[0-9][a-c]/wait"$1"}   "${@:2}"; }
zct() { zt load'[[ ${MYPROMPT} = "'${1}'" ]]' unload'[[ ${MYPROMPT} != "'${1}'" ]]' \
atload'!source "${ZPLGM[PLUGINS_DIR]}/_local---config-files/themes/${MYPROMPT}"' "${@:2}"; }

# Initial Prompt and config source
zt pick'async.zsh'
z mafredri/zsh-async

MYPROMPT="${MYPROMPT:-spaceship-async}"
zt if'[[ $MYPROMPT = "spaceship-async"  ]]' pick'spaceship.zsh' compile'{lib/*,sections/*,tests/*.zsh}' \
atload'!source "${ZPLGM[PLUGINS_DIR]}/_local---config-files/themes/${MYPROMPT}"' silent
z load maximbaz/spaceship-prompt

zt blockf
z _local/config-files

# Conditional themes
zct spaceship-async pick'spaceship.zsh' compile'{lib/*,sections/*,tests/*.zsh}'
z load maximbaz/spaceship-prompt

zct spaceship pick'spaceship.zsh' compile'{lib/*,sections/*,tests/*.zsh}'
z load denysdovhan/spaceship-prompt

zct dolphin pick"/dev/null" multisrc"{async,pure}.zsh" reset-prompt
z load sindresorhus/pure

# Oh-my-zsh libs
z snippet OMZ::lib/history.zsh

zt 0a
z snippet OMZ::lib/completion.zsh

# Plugins

#zt atload'ZSH_EVALCACHE_DIR="$ZPFX/.zsh-evalcache"'
#z mroth/evalcache

zt 0b atclone"sed -i '/DIR/c\DIR                   1;34' LS_COLORS; dircolors -b LS_COLORS > c.zsh" \
atpull'%atclone' pick"c.zsh" nocompile'!' reset atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
z trapd00r/LS_COLORS

zt 0a has'systemctl'
z snippet OMZ::plugins/systemd/systemd.plugin.zsh

zt 0a
z snippet OMZ::plugins/extract/extract.plugin.zsh

zt 0b compile'{hsmw-*,test/*}'
z zdharma/history-search-multi-word

zt 0b
z ael-code/zsh-colored-man-pages

zt 0a make
z sei40kr/zsh-fast-alias-tips

zt wait'[[ -n ${ZLAST_COMMANDS[(r)g*]} ]]' has'git' as'command'
z paulirish/git-open

zt wait'[[ -n ${ZLAST_COMMANDS[(r)g*]} ]]' has'git'
z wfxr/forgit
#replaced gi with local git-ignore plugin

zt wait'[[ -n ${ZLAST_COMMANDS[(r)g*]} ]]' has'git' pick'init.zsh' atload'alias gi="git-ignore"' blockf
z laggardkernel/git-ignore

zt 0a as'program' pick'wd.sh' mv'_wd.sh -> _wd' atload'wd() { source wd.sh }' blockf reset
z mfaerevaag/wd

zt 0a
z NICHOLAS85/updatelocal

zt wait'[[ -n ${ZLAST_COMMANDS[(r)gcom*]} ]]' atload'gcomp(){ \gencomp ${1} && zplugin creinstall -q RobSis/zsh-completion-generator; }' pick'zsh-completion-generator.plugin.zsh'
z RobSis/zsh-completion-generator
#loaded when needed via gcomp

zt 0b as'program' pick'rm-trash/rm-trash' atpull'%atclone' atload'alias rm="rm-trash ${rm_opts}"' \
compile'rm-trash/rm-trash' nocompile'!' reset \
atclone"sed -i '2 i [[ \$EUID = 0 ]] && { echo \"Root detected, running builtin rm\"; command rm -I -v \"\${@}\"; exit; }' rm-trash/rm-trash" 
z nateshmbhat/rm-trash

zt 0b has'thefuck' trackbinds bindmap'\e\e -> ^[OP^[OP' pick'init.zsh'
z laggardkernel/zsh-thefuck

zt 0a
z snippet OMZ::plugins/sudo/sudo.plugin.zsh

zt 0b
z snippet OMZ::plugins/command-not-found/command-not-found.plugin.zsh

zt 0a atload'unalias help; unalias rm'
z snippet OMZ::plugins/common-aliases/common-aliases.plugin.zsh

zt 0a as'program' pick'bin/git-dsf'
z zdharma/zsh-diff-so-fancy

zt 0b pick'autopair.zsh' nocompletions
z hlissner/zsh-autopair

zt 0a blockf atpull'zplugin creinstall -q .'
z zsh-users/zsh-completions

zt wait'[[ ${isdolphin} != true ]]'
z load desyncr/auto-ls

zt 0c atload'bindkey "$terminfo[kcuu1]" history-substring-search-up; bindkey "$terminfo[kcud1]" history-substring-search-down'
z zsh-users/zsh-history-substring-search

zt 0b compile'{src/*.zsh,src/strategies/*}' atload'_zsh_autosuggest_start'
z zsh-users/zsh-autosuggestions

zt 0b pick'manydots-magic' compile'manydots-magic'
z knu/zsh-manydots-magic

# Unique zpcompinit command found in functions folder of config files, not the default
zt 0b atinit'_zpcompinit_fast; zpcdreplay'
z zdharma/fast-syntax-highlighting

zt 0c id-as'Cleanup' atinit'unset -f zt z'
z zdharma/null

$isdolphin || dotscheck
echo
