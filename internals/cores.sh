CORES_VERSION="1.1-0-alpha"
G8UFS_VERSION="1.0.0"

prepare_cores() {
    echo "[+] loading source code: core0"
    go get -d -v github.com/g8os/core0/core0

    echo "[+] loading source code: coreX"
    go get -d -v github.com/g8os/core0/coreX

    echo "[+] loading source code: g8ufs"
    go get -d -v github.com/g8os/g8ufs

    echo "[+] ensure core0 to branch: ${CORES_VERSION}"
    pushd $GOPATH/src/github.com/g8os/core0
    branch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$branch" != "${CORES_VERSION}" ]; then
        git fetch origin "${CORES_VERSION}:${CORES_VERSION}"
        git checkout "${CORES_VERSION}"
    fi
    popd

    echo "[+] ensure g8ufs to branch: ${G8UFS_VERSION}"
    pushd $GOPATH/src/github.com/g8os/g8ufs
    branch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$branch" != "${G8UFS_VERSION}" ]; then
        git fetch origin "${G8UFS_VERSION}:${G8UFS_VERSION}"
        git checkout "${G8UFS_VERSION}"
    fi
    popd
}

compile_cores() {
    echo "[+] compiling coreX and core0"
    make

    echo "[+] compiling g8ufs"
    pushd ../g8ufs/cmd
    go build -ldflags "-s -w"
    popd
}

install_cores() {
    echo "[+] copying binaries"
    cp -a bin/coreX bin/core0 "${ROOTDIR}/sbin/"
    cp -a ../g8ufs/cmd/cmd "${ROOTDIR}/sbin/g8ufs"

    echo "[+] installing configuration"
    mkdir -p "${ROOTDIR}/etc/g8os/conf"
    cp -a core0/conf/* "${ROOTDIR}"/etc/g8os/conf/
    rm -f "${ROOTDIR}"/etc/g8os/conf/README.md
}

build_cores() {
    # We need to prepare first (download code)
    prepare_cores
    pushd $GOPATH/src/github.com/g8os/core0

    compile_cores
    install_cores

    popd
}
