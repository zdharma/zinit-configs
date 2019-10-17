#!/usr/bin/env zsh

case `uname` in
  Darwin)
    brew install fzf
  ;;
  Linux)
    sudo apt install fzf
  ;;
esac
