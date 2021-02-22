#                            __ _ _
#       _____ __  _ __ ___  / _(_) | ___
#      |_  / '_ \| '__/ _ \| |_| | |/ _ \
#     _ / /| |_) | | | (_) |  _| | |  __/
#    (_)___| .__/|_|  \___/|_| |_|_|\___|
#          |_|

#^#---- CLIPBOARD --------------------------------------------------------------
mkdir -p $CLIPBOARD
touch ${CLIPBOARD}/0{0,1,2,3,4}
chmod 700 $CLIPBOARD
chmod 600 ${CLIPBOARD}/*
#$#

#^#---- HOST PROFILE -----------------------------------------------------------
default_profile="${PROFILES}/default"

case "$(uname)" in
    FreeBSD) host="$(grep 'hostname' /etc/rc.conf |
        sed -E 's/\(^.*="\)\(.*\.\)\(.*$\)/\2/')" ;;
    Linux) host="$(cat /etc/hostname)" ;;
    OpenBSD) host="$(cat /etc/myname | cut -d '.' -f 1)" ;;
    *) host="$(hostname)" ;;
esac

host_profile="${PROFILES}/${host}"

install_profile(){ #^#
    if [ -d "$1" ]; then
        find "$1" -type f | while IFS= read -r file; do
	    targ="${file##${1}}"
	    targdir="$(dirname "$targ")"

	    if [ ! -d "$targdir" ]; then
	        mkdir -p "$targdir" 2>/dev/null || \
	    	sudo mkdir -p "$targdir"; fi

	    if [ -e "$targ" ] && ! readlink "$targ" 1>/dev/null; then
	        mv "$targ" "${targ}_bu" 2>/dev/null || \
	    	sudo mv "$targ" "${targ}_bu"; fi

	    ln -sfn "$file" "$targ" 2>/dev/null || \
	        sudo ln -sfn "$file" "$targ" 2>/dev/null
    done
    fi
} #$#

install_profile "$default_profile"
install_profile "$host_profile"
#$#

#^#---- NOTIFICATIONS ----------------------------------------------------------
mkdir -p $(dirname $NOTIFICATIONS)
touch $NOTIFICATIONS
chmod 600 $NOTIFICATIONS
#$#

#^#---- VCONSOLE ---------------------------------------------------------------
# sudo -n loadkeys "${XDG_CONFIG_HOME}/kmap/$(cat /etc/hostname)" 2>/dev/null
#$#

# vim: ft=sh fdm=marker fmr=#^#,#$#
