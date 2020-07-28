# https://github.com/NICHOLAS85/dotfiles/blob/xps_13_9365_refresh/.zshrc

# Used to programatically disable plugins when opening the terminal view in dolphin
if [[ $MYPROMPT = dolphin ]]; then
    isdolphin=true
else
    isdolphin=false
    autoload -Uz chpwd_recent_dirs add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':chpwd:*' recent-dirs-file "$TMPDIR/chpwd-recent-dirs"
    (){
        local chpwdrdf
        zstyle -g chpwdrdf ':chpwd:*' recent-dirs-file
        dirstack=($(awk -F"'" '{print $2}' "$chpwdrdf" 2>/dev/null))
        [[ $PWD = ~ ]] && { cd ${dirstack[1]} 2>/dev/null || true }
        dirstack=("${dirstack[@]:1}")
    }
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZINIT_HOME="${ZINIT_HOME:-${ZPLG_HOME:-${ZDOTDIR:-$HOME}/.zinit}}"
ZINIT_BIN_DIR_NAME="${${ZINIT_BIN_DIR_NAME:-$ZPLG_BIN_DIR_NAME}:-bin}"
### Added by Zinit's installer
if [[ ! -f $ZINIT_HOME/$ZINIT_BIN_DIR_NAME/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$ZINIT_HOME" && command chmod g-rwX "$ZINIT_HOME"
    command git clone https://github.com/zdharma/zinit "$ZINIT_HOME/$ZINIT_BIN_DIR_NAME" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$ZINIT_HOME/$ZINIT_BIN_DIR_NAME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

#module_path+=( "${HOME}/.zinit/bin/zmodules/Src" )
#zmodload zdharma/zplugin &>/dev/null

if [[ ! -d "${ZINIT[PLUGINS_DIR]}/_local---config-files" ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing local config-files…%f"
    curl https://codeload.github.com/NICHOLAS85/dotfiles/tar.gz/xps_13_9365_refresh | \
    tar -xz --strip=3 dotfiles-xps_13_9365/.zinit/plugins/_local---config-files
    mv _local---config-files "${ZINIT[PLUGINS_DIR]}/"
fi

# Functions to make configuration less verbose
# zt() : First argument is a wait time and suffix, ie "0a". Anything that doesn't match will be passed as if it were an ice mod. Default ices depth'3' and lucid
# zct(): First argument provides $MYPROMPT value used in load'' and unload'' ices. Sources a config file with tracking for easy unloading using $MYPROMPT value. Small hack to function in for-syntax
zt()  { zinit depth'3' lucid ${1/#[0-9][a-c]/wait"$1"} "${@:2}"; }
zct() {
    thmf="${ZINIT[PLUGINS_DIR]}/_local---config-files/themes"
    if [[ ${1} != ${MYPROMPT=p10k} ]] && { ___turbo=1; .zinit-ice \
    load"[[ \${MYPROMPT} = ${1} ]]" unload"[[ \${MYPROMPT} != ${1} ]]" }
    .zinit-ice atload'! [[ -f "${thmf}/${MYPROMPT}-post.zsh" ]] && source "${thmf}/${MYPROMPT}-post.zsh"' \
    nocd id-as"${1}-theme";
    ICE+=("${(kv)ZINIT_ICES[@]}"); ZINIT_ICES=();
}

##################
# Initial Prompt #
#    Annexes     #
# Config source  #
##################

zt light-mode for \
    pick'async.zsh' \
        mafredri/zsh-async \
        romkatv/powerlevel10k \

zt for if'zct dolphin' \
        zdharma/null \
    if'zct p10k' \
        zdharma/null

zt light-mode compile'*handler' for \
        zinit-zsh/z-a-patch-dl \
        zinit-zsh/z-a-bin-gem-node \
        zinit-zsh/z-a-submods

zt light-mode blockf for \
        _local/config-files

###########
# Plugins #
###########

zt atinit'HISTFILE="${HOME}/.histfile"' for \
    OMZL::history.zsh

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
    atload'alias gencomp="zinit silent nocd as\"null\" wait\"2\" atload\"zinit creinstall -q _local/config-files; zicompinit\" for /dev/null; gencomp"' \
        RobSis/zsh-completion-generator

##################
# Wait'0a' block #
##################

zt 0a light-mode for \
        OMZL::completion.zsh \
    if'false' ver'dev' \
        marlonrichert/zsh-autocomplete \
    has'systemctl' \
        OMZP::systemd/systemd.plugin.zsh \
        OMZP::sudo/sudo.plugin.zsh \
    blockf \
        zsh-users/zsh-completions \
    compile'{src/*.zsh,src/strategies/*}' pick'zsh-autosuggestions.zsh' \
    atload'_zsh_autosuggest_start' \
        zsh-users/zsh-autosuggestions \
    pick'fz.sh' atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(autopair-insert __fz_zsh_completion)' \
        changyuheng/fz

##################
# Wait'0b' block #
##################

zt 0b light-mode for \
    pack'no-dir-color-swap' patch"$pchf/%PLUGIN%.patch" reset \
        trapd00r/LS_COLORS \
    compile'{hsmw-*,test/*}' \
        zdharma/history-search-multi-word \
        OMZP::command-not-found/command-not-found.plugin.zsh \
    pick'autopair.zsh' nocompletions atload'bindkey "^H" backward-kill-word; ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(autopair-insert)' \
        hlissner/zsh-autopair \
    trackbinds bindmap'\e[1\;6D -> ^[[1\;5B; \e[1\;6C -> ^[[1\;5A' patch"$pchf/%PLUGIN%.patch" \
    reset pick'dircycle.zsh' \
        michaelxmcbride/zsh-dircycle \
    autoload'#manydots-magic' \
        knu/zsh-manydots-magic \
    pick'autoenv.zsh' nocompletions \
        Tarrasch/zsh-autoenv \
    atinit'zicompinit_fast; zicdreplay' atload'FAST_HIGHLIGHT[chroma-man]=' \
        zdharma/fast-syntax-highlighting \
    atload'bindkey "$terminfo[kcuu1]" history-substring-search-up;
    bindkey "$terminfo[kcud1]" history-substring-search-down' \
        zsh-users/zsh-history-substring-search \
    as'completion' mv'*.zsh -> _git' \
        felipec/git-completion \

##################
# Wait'0c' block #
##################

zt 0c light-mode for \
    pack'bgn-binary' \
        junegunn/fzf \
    sbin from'gh-r' submods'NICHOLAS85/zsh-fast-alias-tips -> plugin' pick'plugin/*.zsh' \
        sei40kr/fast-alias-tips-bin

zt 0c light-mode binary for \
    sbin'fd*/fd;fd*/fd -> fdfind' from"gh-r" \
         @sharkdp/fd \
    sbin'bin/git-ignore' atload'export GI_TEMPLATE="$PWD/.git-ignore"; alias gi="git-ignore"' \
        laggardkernel/git-ignore

zt 0c light-mode null for \
    sbin"bin/git-dsf;bin/diff-so-fancy" \
        zdharma/zsh-diff-so-fancy \
    sbin \
        paulirish/git-open \
    sbin'm*/micro' from"gh-r" ver'nightly' bpick'*linux64*' reset \
        zyedidia/micro \
    sbin'*/rm-trash' atload'alias rm="rm-trash ${rm_opts}"' reset \
    patch"$pchf/%PLUGIN%.patch" \
        nateshmbhat/rm-trash \
    sbin \
        kazhala/dotbare \
    id-as'Cleanup' nocd atinit'unset -f zct zt; SPACESHIP_PROMPT_ADD_NEWLINE=true; _zsh_autosuggest_bind_widgets' \
        zdharma/null
