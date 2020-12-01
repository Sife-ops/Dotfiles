#!/bin/sh

# hosts file
if [ "$(wc -l /etc/hosts | cut -d' ' -f1)" -lt "3" ]; then
cat > /etc/hosts << 'EOL'
# Static table lookup for hostnames.
# See hosts(5) for details.
127.0.0.1           localhost
::1                 localhost
127.0.1.1           <hostname>.geofront     <hostname>

192.168.69.1        russianbot.geofront     russianbot
192.168.69.2        casper.geofront         casper
192.168.69.3        nothingburger.geofront  nothingburger
192.168.69.4        45savage.geofront       45savage
EOL
fi

# pacman colors
if ! grep '^Color$' /etc/pacman.conf >/dev/null 2>&1; then
    sed -i '/^# Misc options$/a Color' /etc/pacman.conf
fi
if ! grep '^ILoveCandy$' /etc/pacman.conf >/dev/null 2>&1; then
    sed -i '/^# Misc options$/a ILoveCandy' /etc/pacman.conf
fi

# enable barrier for xdm
if [ "$(cat /etc/hostname)" != "casper" ] \
&& [ -f /etc/X11/xdm/Xsetup_0 ] \
&& ! grep '^barrierc casper$' /etc/X11/xdm/Xsetup_0 >/dev/null 2>&1; then
    echo 'barrierc casper' >> /etc/X11/xdm/Xsetup_0
fi
