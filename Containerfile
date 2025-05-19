ARG RHEL_VER="9.5"
ARG RHEL_TAG=""

FROM registry.redhat.io/rhel9/rhel-bootc:${RHEL_VER}${RHEL_TAG}

ARG RHEL_VER
RUN dnf -y --releasever=$RHEL_VER install rhc rhc-worker-playbook insights-client qemu-kvm libvirt virt-install virt-viewer podman buildah skopeo cockpit cockpit-machines cockpit-podman cockpit-storaged cockpit-networkmanager cockpit-pcp cockpit-files NetworkManager-wifi mkpasswd iwl7260-firmware firewalld vim libvirt-nss guestfs-tools && dnf clean all 

RUN echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/wheel-sudo

COPY homeNG5.nmconnection /etc/NetworkManager/system-connections/
COPY routed-default.xml /root/
COPY bootc-builder.xml /root/

RUN systemctl enable podman.socket cockpit.socket pmlogger.service fstrim.timer
RUN systemctl mask bootc-fetch-apply-updates.timer

RUN bootc container lint
