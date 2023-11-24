#!/bin/bash

# dest
destiny="$PWD/x86_64"

# create tmp build
tput setaf 10
echo "> Creating build folder"
tput sgr0
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
  chown -R 1000:1000 .
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

# create tmp build
tput setaf 10
echo "> Deleting build folder"
tput sgr0
rm -rf /tmp/ctos-build

# generate repo db
tput setaf 10
echo "> Generating repo database"
tput sgr0
repo-add $destiny/ctOS.db.tar.gz $destiny/*.pkg.tar.zst
find $destiny -maxdepth 1 -type l -delete
mv ctOS.db.tar.gz ctOS.db
mv ctOS.files.tar.gz ctOS.files
