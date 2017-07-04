OPENSSH_VERSION="7.5p1"
OPENSSH_CHECKSUM="652fdc7d8392f112bef11cacf7e69e23"
OPENSSH_LINK="https://ftp.fr.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${OPENSSH_VERSION}.tar.gz"

download_openssh() {
    download_file $OPENSSH_LINK $OPENSSH_CHECKSUM
}

extract_openssh() {
    if [ ! -d "openssh-${OPENSSH_VERSION}" ]; then
        echo "[+] extracting: openssh-${OPENSSH_VERSION}"
        tar -xf ${DISTFILES}/openssh-${OPENSSH_VERSION}.tar.gz -C .
    fi
}

prepare_openssh() {
    echo "[+] preparing openssh"
    ./configure --prefix=/ \
        --without-kerberos \
        --without-kerberos5 \
        --without-ldns \
        --with-pie \
		--without-libedit \
		--without-pam \
		--without-sctp \
		--without-selinux \
		--without-skey \
		--without-ssh1 \
        --without-shadow \
		--disable-strip

        # --with-ssl-dir=PATH

}

compile_openssh() {
    echo "[+] compiling openssh"
    make ${MAKEOPTS}
}

install_openssh() {
    echo "[+] installing openssh"
    make DESTDIR="${ROOTDIR}" install

    mkdir -p -m 700 "${ROOTDIR}"/root/.ssh
}

build_openssh() {
    pushd "${WORKDIR}/openssh-${OPENSSH_VERSION}"

    prepare_openssh
    compile_openssh
    install_openssh

    popd
}
