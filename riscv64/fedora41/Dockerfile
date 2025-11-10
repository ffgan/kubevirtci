FROM fedorariscv/base:41 AS base

RUN dnf -y install jq iptables iproute dnsmasq qemu socat openssh-clients screen bind-utils tcpdump iputils libguestfs-tools-c && dnf clean all


FROM base AS imageartifactdownload

ARG BUILDARCH

WORKDIR /

COPY scripts/download_box.sh /

RUN  /download_box.sh https://dl.fedoraproject.org/pub/alt/risc-v/release/42/Cloud/riscv64/images/Fedora-Cloud-Base-Generic-42.20250911-2251ba41cdd3.riscv64.qcow2 && \
    # Access virtual machine disk images directly by using LIBGUESTFS_BACKEND=direct, instead of libvirt
    export LIBGUESTFS_BACKEND=direct && \
    guestfish --ro --add box.qcow2 --mount /dev/sda1:/ ls /boot/ | grep -E '^vmlinuz-|^initramfs-' | xargs -I {} guestfish --ro --add box.qcow2 -i copy-out /boot/{} / ; 


FROM base AS nodecontainer

ARG BUILDARCH
       
WORKDIR /

COPY vagrant.key /vagrant.key

RUN chmod 700 vagrant.key

ENV DOCKERIZE_VERSION=v0.9.7

RUN curl -L -o dockerize-linux-$BUILDARCH.tar.gz https://github.com/ffgan/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-riscv64-$DOCKERIZE_VERSION.tar.gz && \
    tar -xzvf dockerize-linux-$BUILDARCH.tar.gz && \
    rm dockerize-linux-$BUILDARCH.tar.gz && \
    chmod u+x dockerize && \
    mv dockerize /usr/local/bin/

COPY --from=imageartifactdownload /box.qcow2 box.qcow2
COPY --from=imageartifactdownload /vmlinuz-* /vmlinuz
COPY --from=imageartifactdownload /initramfs-* /initrd.img

COPY scripts/* /
