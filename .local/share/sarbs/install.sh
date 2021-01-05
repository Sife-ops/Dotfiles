#!/bin/sh

msg_help() { echo \
"Usage:
    install.sh [OPTIONS]

Options:
    -a  install all
    -B  install barrierc on XDM
    -b  install bspwm
    -c  install crontab
    -H  install the hosts file
    -p  install pacman options
    -h  print this message"
}

while getopts "aBbcHph" o; do case "${o}" in
	a) tasks=("installBarrierc" "installBspwm" "installCrontab" "installHosts" "installPacman") && break ;; # array of all tasks
	B) tasks+=("installBarrierc") ;;
	b) tasks+=("installBspwm") ;;
	c) tasks+=("installCrontab") ;;
	H) tasks+=("installHosts") ;;
	p) tasks+=("installPacman") ;;
    h) msg_help ;;
	*) printf "Invalid option: -%s\\n" "$o" && msg_help && exit 1 ;;
esac done
[ "$#" -lt "1" ] && msg_help && exit 1

function installXorg() {
    echo imgay
}

function installBspwm() {
    installXorg
}

function installCrontab(){
    if [ ! -e /var/spool/cron/$(id -un) ]
    then
        echo \
"@reboot /usr/bin/pacman -Qqen > ~/.local/share/sarbs/profiles/$(uname -n)/.local/share/sarbs/paclist
@reboot /usr/bin/pacman -Qqem > ~/.local/share/sarbs/profiles/$(uname -n)/.local/share/sarbs/aurlist" \
        > /var/spool/cron/$(id -un)
    fi

    if [ ! -e /var/spool/cron/root ]
    then
        echo \
"@hourly /usr/bin/pacman -Sy" \
        > /var/spool/cron/root
    fi
}

function installHosts() {
    if [ "$(wc -l /etc/hosts | cut -d' ' -f1)" -lt "3" ]
    then
        echo \
"# Static table lookup for hostnames.
# See hosts(5) for details.
127.0.0.1           localhost
::1                 localhost
127.0.1.1           $(uname -n).geofront    $(uname -n)

# 192.168.69.1        russianbot.geofront     russianbot
# 192.168.69.2        casper.geofront         casper
# 192.168.69.3        nothingburger.geofront  nothingburger
# 192.168.69.4        45savage.geofront       45savage" \
        > /etc/hosts
    fi
}

function installPacman() {
    if ! grep '^Color$' /etc/pacman.conf >/dev/null 2>&1
    then
        sed -i '/^# Misc options$/a Color' /etc/pacman.conf
    fi
    if ! grep '^ILoveCandy$' /etc/pacman.conf >/dev/null 2>&1
    then
        sed -i '/^# Misc options$/a ILoveCandy' /etc/pacman.conf
    fi
}

function installBarrierc() {
    if [ "$(cat /etc/hostname)" != "casper" ] \
        && [ -f /etc/X11/xdm/Xsetup_0 ] \
        && ! grep '^barrierc casper&$' /etc/X11/xdm/Xsetup_0 >/dev/null 2>&1
        then
            echo 'barrierc casper &' >> /etc/X11/xdm/Xsetup_0
    fi
}

for task in ${tasks[@]}
do
    eval $task
done
