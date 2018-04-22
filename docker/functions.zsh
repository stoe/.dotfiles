#!/bin/zsh

source "$HOME/.dotfiles/inc/helpers.sh"

function dstop() {
  question "Do you really want to stop all 🐳  docker containers?" "yn"
  read -rs -k 1 ask
  print -P "%F{8}> $ask%f"

  if [ "$ask" = "y" ]; then
    docker stop $(docker ps -a -q)
  else
    abort "docker stop"
  fi
}

function dclean() {
  question "Do you really want to delete all 🐳  docker containers and images?" "yn"
  read -rs -k 1 ask
  print -P "%F{8}> $ask%f"

  if [ "$ask" = "y" ]; then
    docker rm -f $(docker ps -a -q)
  else
    abort "docker clean"
  fi

  unset $ask;

  question "Do you really want to delete all 🐳  docker images?" "yn"
  read -rs -k 1 ask
  print -P "%F{8}> $ask%f"

  if [ "$ask" = "y" ]; then
    docker rmi $(docker images -q)
  else
    abort "docker clean"
  fi
}
