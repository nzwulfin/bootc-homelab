ARG RHEL_VER="10.0"
ARG RHEL_TAG=""

FROM registry.redhat.io/rhel10/rhel-bootc:${RHEL_VER}${RHEL_TAG}

ARG RHEL_VER
RUN dnf -y install rhc rhc-worker-playbook insights-client qemu-kvm libvirt virt-install virt-viewer podman buildah skopeo cockpit cockpit-machines cockpit-podman cockpit-storaged cockpit-networkmanager cockpit-files NetworkManager-wifi mkpasswd iwl7260-firmware firewalld vim libvirt-nss guestfs-tools pcp python3-pcp && dnf clean all 

RUN echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/wheel-sudo

RUN systemctl enable podman.socket cockpit.socket fstrim.timer pmlogger.service
RUN systemctl mask bootc-fetch-apply-updates.timer

RUN rm /var/{cache,lib}/* -rf
RUN bootc container lint
