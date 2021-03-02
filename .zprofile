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
        sed -E 's/(^.*=")(.*\.)(.*$)/\2/')" ;;
    Linux) host="$(cat /etc/hostname)" ;;
    OpenBSD) host="$(cat /etc/myname | cut -d '.' -f 1)" ;;
    *) host="$(hostname)" ;;
esac

host_profile="${PROFILES}/${host}"

install_profile(){ #^#
    if [ -d "$1" ]; then
        find "$1" -type f | while IFS= read -r file; do
	    target="${file##${1}}"
	    directory="$(dirname "$target")"

	    if [ ! -d "$directory" ]; then
	        # mkdir -p "$directory" || \
	        mkdir -p "$directory" 2>/dev/null || \
	    	sudo mkdir -p "$directory"; fi

	    if [ -e "$target" ] && \
	    	! readlink "$target" 1>/dev/null && \
            [ ! -f "${target}_bu" ]; then
	        # mv "$target" "${target}_bu" || \
	    	# sudo mv "$target" "${target}_bu"; fi
	        mv "$target" "${target}_bu" 2>/dev/null || \
	    	sudo mv "$target" "${target}_bu"; fi

	    # ln -sfn "$file" "$target" || \
	    #     sudo cp "$file" "$target"
	    ln -sfn "$file" "$target" 2>/dev/null || \
	        sudo cp "$file" "$target" 2>/dev/null
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
# case "$(uname)" in
#     Linux) sudo -n loadkeys "${XDG_CONFIG_HOME}/kmap/$(cat /etc/hostname)" 2>/dev/null
# esac
#$#

# vim: ft=sh fdm=marker fmr=#^#,#$#
