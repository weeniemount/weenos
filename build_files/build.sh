#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux fastfetch htop cowsay feh ffplay pkill plasma-workspace-x11 distrobox
dnf5 remove -y firefox

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

# download google balls

curl -L -o /tmp/gtk-app-linux-x64.tar.gz \
  https://github.com/weeniemount/googleballs-app/releases/latest/download/gtk-app-linux-x64.tar.gz

tar -xzf /tmp/gtk-app-linux-x64.tar.gz -C /usr/weenos/balls --no-same-owner

rm -f /usr/weenos/balls/README.txt

rm -f /tmp/gtk-app-linux-x64.tar.gz

# maxwell!

git clone https://github.com/wilversings/maxwell /usr/share/plasma/plasmoids/maxwell/

# apply the le custom weenOS plymouth boot theme
sudo plymouth-set-default-theme logo-slider

# download the news

curl -L -o /usr/weenos/news/thenews \
  https://github.com/weeniemount/thenews-linux/releases/latest/download/thenews
chmod +x /usr/weenos/news/thenews

# SDDM fix from the bazzite repo as of Fedora 43
sed -i '/^StartLimitBurst=2$/a # Wait for driver loading to be complete so that graphics work\n# (https://github.com/sddm/sddm/issues/1917)\nWants=systemd-udev-settle.service\nAfter=systemd-udev-settle.service' /usr/lib/systemd/system/sddm.service

# and then forcefully rebuild initrd!!!!... maybe this one will work
QUALIFIED_KERNEL="$(dnf5 repoquery --installed --queryformat='%{evr}.%{arch}' "kernel")"
/usr/bin/dracut --no-hostonly --kver "$QUALIFIED_KERNEL" --reproducible --zstd -v --add ostree --add fido2 -f "/usr/lib/modules/$QUALIFIED_KERNEL/initramfs.img"

chmod 0600 /usr/lib/modules/"$QUALIFIED_KERNEL"/initramfs.img

# install app image launcher
curl -L -o /tmp/appimagelauncher.rpm \
  https://github.com/TheAssassin/AppImageLauncher/releases/download/v3.0.0-beta-3/appimagelauncher_3.0.0-beta-2-gha287.96cb937_x86_64.rpm

# create a temporary extraction directory
mkdir -p /tmp/appimagelauncher-extract
cd /tmp/appimagelauncher-extract

# extract the RPM
rpm2cpio /tmp/appimagelauncher.rpm | cpio -idmv

# move the AppDir to a safe location
mkdir -p /usr/share
if [ -d opt/appimagelauncher.AppDir ]; then
  mv opt/appimagelauncher.AppDir /usr/share/AppImageLauncher.AppDir
fi

# copy binaries to system paths
if [ -d usr/bin ]; then
  cp usr/bin/* /usr/bin/ 2>/dev/null || true
fi

# copy libraries
if [ -d usr/lib ]; then
  cp -r usr/lib/* /usr/lib/ 2>/dev/null || true
fi

# install desktop files
if [ -d /usr/share/AppImageLauncher.AppDir/usr/share/applications ]; then
  cp /usr/share/AppImageLauncher.AppDir/usr/share/applications/* /usr/share/applications/ 2>/dev/null || true
fi

# copy icons
if [ -d /usr/share/AppImageLauncher.AppDir/usr/share/icons ]; then
  cp -r /usr/share/AppImageLauncher.AppDir/usr/share/icons/* /usr/share/icons/ 2>/dev/null || true
fi

# copy mime packages
if [ -d usr/share/mime ]; then
  cp -r usr/share/mime/* /usr/share/mime/ 2>/dev/null || true
fi

# update desktop database
update-desktop-database /usr/share/applications/ 2>/dev/null || true

# cleanup
cd /
rm -rf /tmp/appimagelauncher-extract
rm -f /tmp/appimagelauncher.rpm