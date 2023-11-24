#!/bin/bash

# dest
destiny="x86_64"

# create tmp build
tput setaf 10
echo "> Creating build folder"
tput sgr0
mkdir $PWD/ctos-build
export TMPBUILD=$PWD/ctos-build

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
  makepkg -s --noconfirm
  cd ..
done

# mv pkgs / delete build folder
tput setaf 10
echo "> Moving pkgs / deleting build folder"
tput sgr0
for d in $TMPBUILD/*; do
  echo Cleaning $d..
  cd $d
  # mv pkgs
  mv -vn *pkg.tar.zst $destiny &> /dev/null
  mv -vn *pkg.tar.zst.sig $destiny &> /dev/null
  cd ..
done
rm -rf $TMPBUILD

# generate repo db
tput setaf 10
echo "> Generating repo database"
tput sgr0
repo-add $destiny/ctOS.db.tar.gz $destiny/*.pkg.tar.zst
find $destiny -maxdepth 1 -type l -delete
mv $destiny/ctOS.db.tar.gz $destiny/ctOS.db
mv $destiny/ctOS.files.tar.gz $destiny/ctOS.files
