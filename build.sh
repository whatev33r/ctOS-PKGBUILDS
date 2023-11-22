#!/bin/bash

# var
destiny="$PWD/x86_64"
builddir="/tmp/ctos-tmp"

# spawn folders
tput setaf 10
echo "> Cleaning /tmp/ctos-chroot"
tput sgr0

rm -rf /tmp/ctos-chroot
mkdir /tmp/ctos-chroot
export CHROOT=/tmp/ctos-chroot

# generate chroot
tput setaf 10
echo "> Setting up chroot env in $CHROOT"
tput sgr0

mkarchroot -M configs/makepkg.conf -C configs/pacman.conf $CHROOT/root base-devel
arch-nspawn $CHROOT/root pacman -Syu &> /dev/null

# build pkgs
tput setaf 10
echo "> Building pkgs"
tput sgr0

for d in packages/*; do
  tput setaf 8
  echo Building $d..
  tput sgr0
  cd $d
  makechrootpkg -r $CHROOT
  cd ../../
done

# clean folder & mv pkgs
tput setaf 10
echo "> Cleaning folders"
tput sgr0

for d in packages/*; do
  echo Cleaning $d..
  cd $d
  # mv pkgs
  mv -n *pkg.tar.zst $destiny &> /dev/null
  mv -n *pkg.tar.zst.sig $destiny &> /dev/null
  # clean folder
  if [[ -f $wpdpath/*.log ]]; then
    rm $pwdpath/*.log
  fi
  if [[ -f $wpdpath/*.deb ]]; then
    rm $pwdpath/*.deb
  fi
  if [[ -f $wpdpath/*.tar.gz ]]; then
    rm $pwdpath/*.tar.gz
  fi
  cd ../../
done

# generate repo db
tput setaf 10
echo "> Generating repo database"
tput sgr0

repo-add $destiny/ctOS.db.tar.gz $destiny/*.pkg.tar.zst
