# https://github.com/NICHOLAS85/dotfiles/blob/xps_13_9365/.zshrc

ZINIT_HOME="${ZINIT_HOME:-${ZPLG_HOME:-${ZDOTDIR:-$HOME}/.zinit}}"
ZINIT_BIN_DIR_NAME="${${ZINIT_BIN_DIR_NAME:-$ZPLG_BIN_DIR_NAME}:-bin}"
### Added by Zinit's installer
if [[ ! -f $ZINIT_HOME/$ZINIT_BIN_DIR_NAME/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p $ZINIT_HOME
    command git clone https://github.com/zdharma/zinit $ZINIT_HOME/$ZINIT_BIN_DIR_NAME && \\
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \\
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$ZINIT_HOME/$ZINIT_BIN_DIR_NAME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

module_path+=( "${HOME}/.zinit/bin/zmodules/Src" )
zmodload zdharma/zplugin &>/dev/null

if [[ ! -d "${ZINIT[PLUGINS_DIR]}/_local---config-files" ]]; then
    curl https://codeload.github.com/NICHOLAS85/dotfiles/tar.gz/xps_13_9365 | \
    tar -xz --strip=3 dotfiles-xps_13_9365/.zinit/plugins/_local---config-files
    mv _local---config-files "${ZINIT[PLUGINS_DIR]}/"
fi

# Functions to make configuration less verbose
# zt() : First argument is a wait time and suffix, ie "0a". Anything that doesn't match will be passed as if it were an ice mod. Default ices depth'3' and lucid
# zct(): First argument provides $MYPROMPT value used in load'' and unload'' ices. Sources a config file with tracking for easy unloading using $MYPROMPT value. Small hack to function in for-syntax
zt()  { zinit depth'3' lucid ${1/#[0-9][a-c]/wait"$1"} "${@:2}"; }
zct() { .zinit-ice load"[[ \${MYPROMPT} = ${1} ]]" unload"[[ \${MYPROMPT} != ${1} ]]" \
        atinit'[ -f "${thmf}/${MYPROMPT}-pre" ] && source "${thmf}/${MYPROMPT}-pre"' \
        atload'![ -f "${thmf}/${MYPROMPT}-post" ] && source "${thmf}/${MYPROMPT}-post"'; \
        ZINIT_ICE+=( "${(kv)ZINIT_ICES[@]}"); }

##################
# Initial Prompt #
# Config source  #
##################

zt for \
    pick'async.zsh' light-mode \
        mafredri/zsh-async \
    if'[[ ${MYPROMPT=spaceship-async} = "spaceship-async" ]]' \
    compile'{lib/*,sections/*,tests/*.zsh}' pick'spaceship.zsh' silent \
    atload'!source "../_local---config-files/themes/${MYPROMPT}-post"' \
        maximbaz/spaceship-prompt \
    blockf light-mode \
        _local/config-files

###########
# Annexes #
###########

zt light-mode for \
        zinit-zsh/z-a-patch-dl \
        zinit-zsh/z-a-bin-gem-node

############################
# Conditional themes block #
############################

zt pick'spaceship.zsh' compile'{lib/*,sections/*,tests/*.zsh}' for \
    if'zct spaceship-async' \
        maximbaz/spaceship-prompt \
    if'zct spaceship' \
        denysdovhan/spaceship-prompt

zt pick"pure.zsh" patch"$pchf/%PLUGIN%.patch" nocompile'!' reset reset-prompt for \
    if'zct dolphin' \
        sindresorhus/pure

# Plugins

zt for  OMZ::lib/history.zsh

##################
# Wait'0a' block #
##################

zt 0a light-mode for \
    pick'fz.sh' \
        changyuheng/fz \
        OMZ::lib/completion.zsh \
    has'systemctl' patch"$pchf/systemd.patch" nocompile'!' \
        OMZ::plugins/systemd/systemd.plugin.zsh \
        sei40kr/zsh-fast-alias-tips \
        OMZ::plugins/sudo/sudo.plugin.zsh \
    blockf atpull'zinit creinstall -q "$PWD"' \
        zsh-users/zsh-completions \
    compile'{src/*.zsh,src/strategies/*}' atload'_zsh_autosuggest_start' \
        zsh-users/zsh-autosuggestions

##################
# Wait'0b' block #
##################

zt 0b light-mode for \
    atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' \
    patch"$pchf/%PLUGIN%.patch" pick"c.zsh" nocompile'!' reset \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”' \
        trapd00r/LS_COLORS \
    compile'{hsmw-*,test/*}' \
        zdharma/history-search-multi-word \
    has'thefuck' trackbinds bindmap'\e\e -> ^[OP^[OP' pick'init.zsh' \
        laggardkernel/zsh-thefuck \
        OMZ::plugins/command-not-found/command-not-found.plugin.zsh \
    pick'autopair.zsh' nocompletions \
        hlissner/zsh-autopair \
    pick'manydots-magic' \
        knu/zsh-manydots-magic \
    pick'autoenv.zsh' nocompletions \
        Tarrasch/zsh-autoenv \
    atinit'zpcompinit_fast; zpcdreplay' \
        zdharma/fast-syntax-highlighting \
    atload'bindkey "$terminfo[kcuu1]" history-substring-search-up;
    bindkey "$terminfo[kcud1]" history-substring-search-down' \
        zsh-users/zsh-history-substring-search

zt 0b if'[[ ${isdolphin} != true ]]' patch"$pchf/%PLUGIN%.patch" for \
        desyncr/auto-ls

##################
# Wait'0c' block #
##################

zt 0c light-mode pick'/dev/null' for \
    sbin'fd*/fd; fd*/fd -> fdfind' from"gh-r" \
         @sharkdp/fd \
    sbin'bin/git-ignore' atload'export GI_TEMPLATE="$PWD/.git-ignore"' \
        laggardkernel/git-ignore

zt 0c light-mode as'null' sbin for \
    sbin"bin/git-dsf;bin/diff-so-fancy" \
        zdharma/zsh-diff-so-fancy \
        paulirish/git-open \
    sbin'm*/micro' from"gh-r" ver'nightly' bpick'*linux64*' reset \
        zyedidia/micro \
    sbin'*/rm-trash' atload'alias rm="rm-trash ${rm_opts}"' reset \
    patch"$pchf/%PLUGIN%.patch" \
        nateshmbhat/rm-trash \
    from'gh-r' \
        junegunn/fzf-bin \
    from'gh-r' \
        sei40kr/fast-alias-tips-bin \
    id-as'Cleanup' nocd atinit'unset -f zct zt' \
        zdharma/null

######################
# Trigger-load block #
######################

zt light-mode for \
    trigger-load'!x' \
        OMZ::plugins/extract/extract.plugin.zsh \
    trigger-load'!man' \
        ael-code/zsh-colored-man-pages \
    trigger-load'!ga;!gcf;!gclean;!gd;!glo;!grh;!gss' \
        wfxr/forgit \
    trigger-load'!zshz' blockf \
        agkozak/zsh-z \
    trigger-load'!updatelocal' blockf \
        NICHOLAS85/updatelocal \
    trigger-load'!gencomp' pick'zsh-completion-generator.plugin.zsh' blockf \
    atload'alias gencomp="zinit lucid nocd as\"null\" wait\"1\" atload\"zinit creinstall -q _local/config-files; zpcompinit\" for /dev/null; gencomp"' \
        RobSis/zsh-completion-generator

$isdolphin || {
dotscheck
[[ $PWD = ~ ]] && { cd "$(cat $TMPDIR/olddir)" } 2>/dev/null || true
trap @shexit EXIT
}
