KERNEL_VERSION="4.9.91"
KERNEL_CHECKSUM="cbf5ec8291d91484a7374126fe5dd26a"
KERNEL_LINK="https://www.kernel.org/pub/linux/kernel/v4.x/linux-${KERNEL_VERSION}.tar.xz"

download_kernel() {
    download_file $KERNEL_LINK $KERNEL_CHECKSUM
}

extract_kernel() {
    if [ ! -d "linux-${KERNEL_VERSION}" ]; then
        echo "[+] extracting: linux-${KERNEL_VERSION}"
        tar -xf ${DISTFILES}/linux-${KERNEL_VERSION}.tar.xz -C .
    fi
}

prepare_kernel() {
    echo "[+] copying kernel configuration"
    cp "${CONFDIR}/build/kernel-config-generic" .config

    # FIXME: add patch for secureboot
}

compile_kernel() {
    if [[ $DO_ALL == 1 ]] || [[ $DO_KMODULES == 1 ]]; then
        echo "[+] compiling the kernel (modules)"
        make ${MAKEOPTS} modules
        make INSTALL_MOD_PATH="${ROOTDIR}" modules_install
        depmod -a -b "${ROOTDIR}" "${KERNEL_VERSION}-Zero-OS"
    fi

    if [[ $DO_ALL == 1 ]] || [[ $DO_KERNEL == 1 ]]; then
        echo "[+] compiling the kernel (vmlinuz)"
        make ${MAKEOPTS}
    fi
}

install_kernel() {
    cp arch/x86/boot/bzImage "${WORKDIR}"/vmlinuz.efi
    echo "[+] kernel installed: ${WORKDIR}/vmlinuz.efi"
}

build_kernel() {
    pushd "${WORKDIR}/linux-${KERNEL_VERSION}"

    prepare_kernel
    compile_kernel
    install_kernel

    popd
}

registrar_kernel() {
    DOWNLOADERS+=(download_kernel)
    EXTRACTORS+=(extract_kernel)
}

registrar_kernel
