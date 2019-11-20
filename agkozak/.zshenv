# ~/.zshenv
#
# https://github.com/agkozak/dotfiles

# Benchmarks
typeset -F SECONDS=0

# if ~/.profile has not been loaded and /etc/zsh/zshenv has
if [[ -z $ENV ]] && [[ -n $PATH ]]; then
  case $- in
    *l*) ;;
    *) [[ -f ${HOME}/.profile ]] && source ${HOME}/.profile ;;
  esac
fi

# Add snap binary and desktop directories to environment
if whence -w snap &> /dev/null && [[ -f /etc/profile.d/apps-bin-path.sh ]]; then
  if [[ ! $PATH == */snap/bin* ]] || [[ ! $XDG_DATA_DIRS == */snapd/* ]]; then
    emulate sh
    source /etc/profile.d/apps-bin-path.sh
    emulate zsh
  fi
fi

[[ -f ${HOME}/.zshenv.local ]] && source ${HOME}/.zshenv.local

# Benchmarks
typeset -g AGKDOT_ZSHENV_BENCHMARK=${$(( SECONDS * 1000))%.*}

# vim: ai:fdm=marker:ts=2:et:sts=2:sw=2
