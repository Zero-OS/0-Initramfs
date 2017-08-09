#!/bin/bash

ROOTBUNTU="/tmp/ubuntu-xenial"
TARGET="/tmp/ubuntu-debugfs.tar.gz"

# preparing target
mkdir -p ${ROOTBUNTU}
rm -rf ${ROOTBUNTU}/*
rm -rf ${TARGET}

# installing system
debootstrap \
  --arch=amd64 \
  --components=main,restricted,universe,multiverse \
  --include curl,ca-certificates,tcpdump,ethtool,pciutils,strace,lsof,htop,binutils \
  xenial ${ROOTBUNTU} \
  http://archive.ubuntu.com/ubuntu/

echo "Debugfs base system installed"

files=$(find ${ROOTBUNTU} | wc -l)
rootsize=$(du -sh ${ROOTBUNTU})
echo "${rootsize}, ${files} files installed"

echo "Cleaning installation..."

# cleaning documentation and not needed files
find ${ROOTBUNTU}/usr/share/doc -type f ! -name 'copyright' | xargs rm -f
find ${ROOTBUNTU}/usr/share/locale -mindepth 1 -maxdepth 1 ! -name 'en' | xargs rm -rf
rm -rf ${ROOTBUNTU}/usr/share/info
rm -rf ${ROOTBUNTU}/usr/share/man
rm -rf ${ROOTBUNTU}/usr/share/lintian
rm -rf ${ROOTBUNTU}/var/cache/apt/archives/*deb
rm -rf ${ROOTBUNTU}/var/lib/apt/lists/*_Packages

files=$(find ${ROOTBUNTU} | wc -l)
rootsize=$(du -sh ${ROOTBUNTU})
echo "${rootsize}, ${files} files installed"

echo "Archiving..."
pushd ${ROOTBUNTU}
tar -czf ${TARGET} *
popd

ls -alh ${TARGET}
echo "Debugfs flist is ready."
