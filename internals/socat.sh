SOCAT_VERSION="1.7.3.1"
SOCAT_CHECKSUM="fbab6334919cbd71433213db18dbbdf0"
SOCAT_LINK="http://www.dest-unreach.org/socat/download/socat-${SOCAT_VERSION}.tar.gz"

download_socat() {
    download_file $SOCAT_LINK $SOCAT_CHECKSUM
}

extract_socat() {
    if [ ! -d "socat-${SOCAT_VERSION}" ]; then
        echo "[+] extracting: socat-${SOCAT_VERSION}"
        tar -xf ${DISTFILES}/socat-${SOCAT_VERSION}.tar.gz -C .
    fi
}

prepare_socat() {
    echo "[+] configuring socat"
    ./configure

    if [ ! -f socat-1.7.3.1-ubuntu.patch ]; then
        echo "[+] downloading patch"
        curl -s https://gist.githubusercontent.com/maxux/a5472530dd88b3480d745388d81e4c7f/raw/743be4c422aedd342be23bfcb45f4cb51967c73b/socat-1.7.3.1-ubuntu.patch > socat-1.7.3.1-ubuntu.patch
        patch -p0 < socat-1.7.3.1-ubuntu.patch
    fi
}

compile_socat() {
    make ${MAKEOPTS}
}

install_socat() {
    cp -avL socat "${ROOTDIR}/usr/bin/"
}

build_socat() {
    pushd "${WORKDIR}/socat-${SOCAT_VERSION}"

    prepare_socat
    compile_socat
    install_socat

    popd
}
