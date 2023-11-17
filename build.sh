#!/bin/bash

# IN PROGRESS

# set destination
destiny="x86_64"

pwdpath=$(echo $PWD)
pwd=$(basename "$PWD")

search=$(basename "$PWD")

rm -rf /tmp/tempbuild
if test -f "/tmp/tempbuild"; then
  rm /tmp/tempbuild
fi
mkdir /tmp/tempbuild
cp -r $pwdpath/packages/*/* /tmp/tempbuild/
#cp -r $pwdpath/.* /tmp/tempbuild

cd /tmp/tempbuild/

tput setaf 2
echo "#############################################################################################"
echo "#########        Let us build the package in CHROOT ~/Documents/chroot-archlinux"
echo "#############################################################################################"
tput sgr0

# Build
mkdir ~/build-chroot
CHROOT=$HOME/build-chroot
mkarchroot $CHROOT/root base-devel
arch-nspawn $CHROOT/root pacman -Syu
makechrootpkg -c -r $CHROOT

#echo "Signing the package"
#echo "#############################################################################################"
#gpg --detach-sign $search*pkg.tar.zst

echo "Moving created files to " $destiny
echo "#############################################################################################"
mv -n $search*pkg.tar.zst $destiny
mv -n $search*pkg.tar.zst.sig $destiny
echo "Cleaning up"
echo "#############################################################################################"
echo "deleting unnecessary folders"
echo "#############################################################################################"

if [[ -f $wpdpath/*.log ]]; then
  rm $pwdpath/*.log
fi
if [[ -f $wpdpath/*.deb ]]; then
  rm $pwdpath/*.deb
fi
if [[ -f $wpdpath/*.tar.gz ]]; then
  rm $pwdpath/*.tar.gz
fi

tput setaf 10
echo "#############################################################################################"
echo "###################                       build done                   ######################"
echo "#############################################################################################"
tput sgr0
