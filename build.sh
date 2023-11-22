#!/bin/bash

# var
destiny="$PWD/x86_64"

# spawn folders
tput setaf 10
echo "> Cleaning /tmp/ctos-chroot"
tput sgr0

rm -rf /tmp/ctos-chroot
rm -rf /tmp/ctos-build
mkdir /tmp/ctos-chroot
mkdir /tmp/ctos-build
export CHROOT=/tmp/ctos-chroot
export TMPBUILD=/tmp/ctos-build

# generate chroot
tput setaf 10
echo "> Setting up chroot env in $CHROOT"
tput sgr0

mkarchroot -M configs/makepkg.conf -C configs/pacman.conf $CHROOT/root base-devel
arch-nspawn $CHROOT/root pacman -Syu &> /dev/null

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
  tput setaf 9
  echo Building $d..
  tput sgr0
  cd $d
  # build in chroot
  makechrootpkg -r $CHROOT
  cd ..
done

# clean folder & mv pkgs
tput setaf 10
echo "> Cleaning folders"
tput sgr0

for d in $TMPBUILD/*; do
  tput setaf 9
  echo Cleaning $d..
  tput sgr0
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

repo-add $destiny/ctOS.db.tar.gz $destiny/*.pkg.tar.zst
