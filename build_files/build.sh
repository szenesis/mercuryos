#!/bin/bash

set -ouex pipefail

# Copy over the base system files
dnf install -y rsync

rsync -rvl --no-acls --no-xattrs --no-owner --no-group --no-perms \
  /ctx/system_files/base/ /
#rsync -rvK /ctx/system_files/base/ /



### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Install terminal software from fedora repos
dnf5 install -y tmux
dnf5 install -y tilix
dnf5 install -y fish
dnf5 install -y docker

#Remove software that is not needed for workflow.
dnf remove -y gnome-software
dnf remove -y gnome-tour
dnf remove -y gnome-system-monitor
dnf remove -y yelp

#Remove old/retro Gnome extensions
dnf remove -y gnome-shell-extension-common
dnf remove -y gnome-shell-extension-apps-menu-
dnf remove -y gnome-shell-extension-launch-new-instance
dnf remove -y gnome-shell-extension-places-menu
dnf remove -y gnome-shell-extension-window-list
dnf remove -y gnome-shell-extension-background-logo
dnf remove -y gnome-shell-extension-appindicator

# Install VS Code
tee /etc/yum.repos.d/vscode.repo <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
sed -i "s/enabled=.*/enabled=0/g" /etc/yum.repos.d/vscode.repo
dnf -y install --enablerepo=code \
    code


#Rechunker fix based on Ziconium and Fizzyblue
chmod +x /usr/bin/rechunker-group-fix
systemctl enable rechunker-group-fix.service


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

