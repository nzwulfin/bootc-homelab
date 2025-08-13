FROM registry.redhat.io/rhel10/rhel-bootc:10.0

# Install packages needed for Insights, containers, virtual machines, cockpit
RUN dnf -y install rhc rhc-worker-playbook insights-client qemu-kvm libvirt virt-install virt-viewer podman buildah skopeo cockpit cockpit-machines cockpit-podman cockpit-storaged cockpit-networkmanager cockpit-files NetworkManager-wifi mkpasswd iwl7260-firmware firewalld vim libvirt-nss guestfs-tools pcp python3-pcp && dnf clean all 

# Passwordless sudo for admins
RUN echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/wheel-sudo

# Enable some default services
RUN systemctl enable podman.socket cockpit.socket fstrim.timer pmlogger.service

# Mask the auto timer so we can control this in a downstream image or host
RUN systemctl mask bootc-fetch-apply-updates.timer

# Enable nss support for virtdomain name resolution
RUN sed -i 's/hosts:\s\+ files/& libvirt libvirt_guest/' /etc/nsswitch.conf

# Remove some targeted build leftovers we won't need in var
RUN rm /var/{cache,lib}/dnf /var/lib/rhsm /var/cache/ldconfig -rf

# For good measure, lint the container
RUN bootc container lint
