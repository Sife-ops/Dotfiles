#                            __ _ _
#       _____ __  _ __ ___  / _(_) | ___
#      |_  / '_ \| '__/ _ \| |_| | |/ _ \
#     _ / /| |_) | | | (_) |  _| | |  __/
#    (_)___| .__/|_|  \___/|_| |_|_|\___|
#          |_|

#---- EVERY LOGIN --------------------------------------------------------------

#---- EVERY RESTART ------------------------------------------------------------
oneShotFile="/tmp/zsh_oneshot_$(id -un)"
if [ ! -f "$oneShotFile" ]; then
    touch "$oneShotFile"

#^#--- INSTALL MENUS -----------------------------------------------------------
ln -sf ${HOME}/.local/bin/menus_fzf/* ${HOME}/.local/bin/
#$#

##^#---- VCONSOLE ---------------------------------------------------------------
#case "$(uname)" in
#    Linux) sudo -n loadkeys "${XDG_CONFIG_HOME}/kmap/$(cat /etc/hostname)" 2>/dev/null
#esac
##$#

fi

#---- EVERY TIME A NEW USER LOGS IN --------------------------------------------
firstLoginFile="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh_firstlogin"
mkdir -p "$(dirname "$firstLoginFile")"
if [ ! -f "$firstLoginFile" ]; then
    touch "$firstLoginFile"

#^#---- CLIPBOARD --------------------------------------------------------------
mkdir -p $CLIPBOARD
touch ${CLIPBOARD}/0{0,1,2,3,4}
chmod 700 $CLIPBOARD
chmod 600 ${CLIPBOARD}/*
#$#

#^#---- NOTIFICATIONS ----------------------------------------------------------
mkdir -p $(dirname $NOTIFICATIONS)
touch $NOTIFICATIONS
chmod 600 $NOTIFICATIONS
#$#

#^#---- HOST PROFILE INSTALLER -------------------------------------------------
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
    [ -d "$1" ] || exit 1
    find "$1" -type f |
        while IFS= read -r file; do
            target="${file##${1}}"
            directory="$(dirname "$target")"

            if [ ! -d "$directory" ]; then
                mkdir -p "$directory" 2>/dev/null || \
                    sudo mkdir -p "$directory"; fi

            if [ -e "$target" ] && \
                ! readlink "$target" 1>/dev/null && \
                [ ! -f "${target}_bu" ]; then
                    mv "$target" "${target}_bu" 2>/dev/null || \
                    sudo mv "$target" "${target}_bu"; fi

            ln -sfn "$file" "$target" 2>/dev/null || \
                sudo cp "$file" "$target" 2>/dev/null
        done
} #$#

install_profile "$default_profile"
install_profile "$host_profile"
#$#

fi

# vim: ft=sh fdm=marker fmr=#^#,#$#
