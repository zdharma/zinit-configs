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

if [[ ! -d "${ZPLGM[PLUGINS_DIR]}/_local---config-files" ]]; then
    curl https://codeload.github.com/NICHOLAS85/dotfiles/tar.gz/xps_13_9365 | \
    tar -xz --strip=3 dotfiles-xps_13_9365/.zplugin/plugins/_local---config-files
    mv _local---config-files "${ZPLGM[PLUGINS_DIR]}/"
fi

# Functions to make configuration less verbose
# zt() : First argument is a wait time and suffix, ie "0a". Anything that doesn't match will be passed as if it were an ice mod. Default ices depth'1' and lucid
# zct(): First argument provides $MYPROMPT value used in load'' and unload'' ices. Sources a config file with tracking for easy unloading using $MYPROMPT value. Small hack to function in for-syntax
zt()  { zplugin depth'1' lucid ${1/#[0-9][a-c]/wait"$1"} "${@:2}"; }
zct() { -zplg-ice load"[[ \${MYPROMPT} = ${1} ]]" unload"[[ \${MYPROMPT} != ${1} ]]" \
        atinit'[ -f "${thmf}/${MYPROMPT}-pre" ] && source "${thmf}/${MYPROMPT}-pre"' \
        atload'![ -f "${thmf}/${MYPROMPT}-post" ] && source "${thmf}/${MYPROMPT}-post"'; \
        ZPLG_ICE+=( "${(kv)ZPLG_ICES[@]}"); }

##################
# Initial Prompt #
# Config source  #
##################

zt for \
    pick'async.zsh' light-mode mafredri/zsh-async \
\
    if'[[ ${MYPROMPT=spaceship-async} = "spaceship-async" ]]' \
    compile'{lib/*,sections/*,tests/*.zsh}' pick'spaceship.zsh' silent \
    atload'!source "../_local---config-files/themes/${MYPROMPT}-post"' \
    maximbaz/spaceship-prompt \
\
    blockf nocompletions light-mode _local/config-files

###########
# Annexes #
###########

zt light-mode for zplugin/z-a-patch-dl

############################
# Conditional themes block #
############################

zt pick'spaceship.zsh' compile'{lib/*,sections/*,tests/*.zsh}' for \
    if'zct spaceship-async' maximbaz/spaceship-prompt \
\
    if'zct spaceship' denysdovhan/spaceship-prompt

zt  if'zct dolphin' pick"pure.zsh" patch"$pchf/pure.patch" nocompile'!' reset-prompt for sindresorhus/pure

# Plugins

zt for OMZ::lib/history.zsh

##################
# Wait'0a' block #
##################

zt 0a light-mode for \
    pick'fz.sh' changyuheng/fz \
\
    OMZ::lib/completion.zsh \
\
    has'systemctl' OMZ::plugins/systemd/systemd.plugin.zsh \
\
    make sei40kr/zsh-fast-alias-tips \
\
    OMZ::plugins/sudo/sudo.plugin.zsh \
\
    atload'unalias help; unalias rm' OMZ::plugins/common-aliases/common-aliases.plugin.zsh \
\
    as'program' pick'bin/git-dsf' zdharma/zsh-diff-so-fancy \
\
    blockf atpull'zplugin creinstall -q "$PWD"' zsh-users/zsh-completions \
\
    compile'{src/*.zsh,src/strategies/*}' atload'_zsh_autosuggest_start' zsh-users/zsh-autosuggestions

##################
# Wait'0b' block #
##################

zt 0b light-mode for \
    patch"$pchf/LS_COLORS.patch" atclone"dircolors -b LS_COLORS > c.zsh" \
    atpull'%atclone' pick"c.zsh" nocompile'!' reset \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”' \
    trapd00r/LS_COLORS \
\
    compile'{hsmw-*,test/*}' zdharma/history-search-multi-word \
\
    as'program' pick'rm-trash/rm-trash' atload'alias rm="rm-trash ${rm_opts}"' \
    patch"$pchf/rm-trash.patch" compile'rm-trash/rm-trash' nocompile'!' reset \
    nateshmbhat/rm-trash \
\
    from"gh-r" as"program" pick'*/micro' bpick'*linux64*' reset zyedidia/micro \
\
    has'thefuck' trackbinds bindmap'\e\e -> ^[OP^[OP' pick'init.zsh' laggardkernel/zsh-thefuck \
\
    OMZ::plugins/command-not-found/command-not-found.plugin.zsh \
\
    pick'autopair.zsh' nocompletions hlissner/zsh-autopair \
\
    pick'manydots-magic' compile'manydots-magic' knu/zsh-manydots-magic \
\
    atinit'_zpcompinit_fast; zpcdreplay' zdharma/fast-syntax-highlighting \
\
    atload'bindkey "$terminfo[kcuu1]" history-substring-search-up; bindkey "$terminfo[kcud1]" history-substring-search-down' \
    zsh-users/zsh-history-substring-search

zt 0b if'[[ ${isdolphin} != true ]]' for desyncr/auto-ls

zt 0c id-as'Cleanup' atinit'unset -f zct zt' as'null' nocd light-mode for zdharma/null 

######################
# Trigger-load block #
######################

zt light-mode for \
    trigger-load'!x' OMZ::plugins/extract/extract.plugin.zsh \
\
    trigger-load'!man' ael-code/zsh-colored-man-pages \
\
    trigger-load'!git' paulirish/git-open \
\
    trigger-load'!ga;!gcf;!gclean;!gd;!gd;!glo;!grh;!gss' wfxr/forgit \
\
    trigger-load'!git-ignore' pick'init.zsh' blockf laggardkernel/git-ignore \
\
    trigger-load'!zshz' blockf agkozak/zsh-z \
\
    trigger-load'!updatelocal' blockf NICHOLAS85/updatelocal \
\
    trigger-load'!gencomp' pick'zsh-completion-generator.plugin.zsh' atload'zplugin creinstall -q "$PWD"' \
    RobSis/zsh-completion-generator

$isdolphin || dotscheck
