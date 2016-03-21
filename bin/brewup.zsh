#!/bin/zsh

# see https://gist.github.com/fvdm/1715d580a22503ce115c#file-homebrew_update-sh
# thanks https://github.com/fvdm

brew=$(which brew)

if [ "$1" = "-h" ]; then
  echo "Colorful Homebrew update script"
  echo
  echo "USAGE: update [-y]"
  echo
  echo "   -y  skip questions"
  echo "   -h  display this help"
  echo
  exit 0
fi

echo "\033[93mFetching packages list:\033[0m"
$brew update
brewsy=`$brew outdated | wc -l | awk {'print $1'}`

if [ $brewsy != 0 ]; then
  echo "\033[93mOutdated packages:\033[0m" $brewsy
  echo
  $brew outdated
  echo

  if [ "$1" != "-y" ]; then
    ask=$(echo "\033[93mUpdate the these packages?\033[92m [yn] \033[0m")
    read -p "$ask" yn
  fi

  if [ "$yn" = "y" ]; then
    $brew upgrade --all && $brew cleanup
  else
    echo "\033[93mOK, not doing anything\033[0m\n"
  fi
else
  echo "\033[93mNothing to do\033[0m"
fi
