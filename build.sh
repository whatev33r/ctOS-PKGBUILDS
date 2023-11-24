#!/bin/bash

# dest
destiny="$PWD/x86_64"

# spawn folders
tput setaf 10
echo "> Cleaning build folder"
tput sgr0

rm -rf /tmp/ctos-build
mkdir /tmp/ctos-build
export TMPBUILD=/tmp/ctos-build

# move pkgs
tput setaf 10
echo "> Moving pkgs"
tput sgr0

cp -v -r packages/* $TMPBUILD

# build pkgs
tput setaf 10
echo "> Building pkgs"
tput sgr0

for d in $TMPBUILD/*; do
  echo Building $d..
  cd $d
  sudo -u "#1000" makepkg -s --noconfirm
  cd ..
done

# clean folder & mv pkgs
tput setaf 10
echo "> Cleaning folders"
tput sgr0

for d in $TMPBUILD/*; do
  echo Cleaning $d..
  cd $d
  # mv pkgs
  mv -n *pkg.tar.zst $destiny &> /dev/null
  mv -n *pkg.tar.zst.sig $destiny &> /dev/null
  cd ..
done

# generate repo db
tput setaf 10
echo "> Generating repo database"
tput sgr0

repo-add $destiny/ctOS-Repo.db.tar.gz $destiny/*.pkg.tar.zst
#find $destiny -maxdepth 1 -type l -delete
#mv ctOS-Repo.db.tar.gz ctOS-Repo.db
#mv ctOS-Repo.files.tar.gz ctOS-Repo.files
