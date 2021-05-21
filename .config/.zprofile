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
# ln -sf ${HOME}/.local/bin/menus_fzf/* ${HOME}/.local/bin/ 1>/dev/null 2>&1
#$#

##^#---- VCONSOLE ---------------------------------------------------------------
#case "$(uname)" in
#    Linux) sudo -n loadkeys "${XDG_CONFIG_HOME}/kmap/$(cat /etc/hostname)" 2>/dev/null
#esac
##$#

fi

#---- EVERY TIME A NEW USER LOGS IN --------------------------------------------
# firstLoginFile="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh_firstlogin"
firstLoginFile="${XDG_CACHE_HOME}/zsh_firstlogin"
mkdir -p "$(dirname "$firstLoginFile")"
if [ ! -f "$firstLoginFile" ]; then
    touch "$firstLoginFile"

#^#---- CLIPBOARD --------------------------------------------------------------
mkdir -p $CLIPBOARD
touch ${CLIPBOARD}/0{0,1,2,3,4}
chmod 700 $CLIPBOARD
chmod 600 ${CLIPBOARD}/*
#$#

#^#---- HOST PROFILE INSTALLER -------------------------------------------------
case $(cat /etc/hostname) in
    45savage)
        sudo cp -b "${PROFILES}/$(cat /etc/hostname)/etc/hosts" /etc/hosts
        ;;
    casper)
        sudo cp -b "${PROFILES}/$(cat /etc/hostname)/etc/hosts" /etc/hosts
        ln -sf \
            "${PROFILES}/$(cat /etc/hostname)/home/$(id-un)/.local/bin/blocks/temperature.sh" \
            "${HOME}/.local/bin/blocks/temperature.sh"
        ln -sf \
            "${PROFILES}/$(cat /etc/hostname)/home/$(id-un)/.local/share/barrier/.barrier.conf" \
            "${XDG_DATA_HOME}/barrier/.barrier.conf"
        ;;
    eltreum)
        sudo cp -b "${PROFILES}/$(cat /etc/hostname)/etc/hosts" /etc/hosts
        sudo cp -b "${PROFILES}/$(cat /etc/hostname)/etc/bitlbee" /etc/
        sudo cp -b "${PROFILES}/$(cat /etc/hostname)/etc/nginx" /etc/
        ;;
    nothingburger)
        sudo cp -b "${PROFILES}/$(cat /etc/hostname)/etc/hosts" /etc/hosts
        sudo cp -b "${PROFILES}/$(cat /etc/hostname)/etc/modules-load.d" /etc/
        ln -sf \
            "${PROFILES}/$(cat /etc/hostname)/home/$(id-un)/.config/autostart/xcape.desktop" \
            "${XDG_CONFIG_HOME}/autostart/xcape.desktop"
        ln -sf \
            "${PROFILES}/$(cat /etc/hostname)/home/$(id-un)/.local/bin/blocks/temperature.sh" \
            "${HOME}/.local/bin/blocks/temperature.sh"
        ln -sf \
            "${PROFILES}/$(cat /etc/hostname)/home/$(id-un)/.local/share/barrier/.barrier.conf" \
            "${XDG_DATA_HOME}/barrier/.barrier.conf"
        ;;
    russianbot)
        sudo cp -b "${PROFILES}/$(cat /etc/hostname)/etc/hosts" /etc/hosts
        ;;
    # *)
    #     ;;
esac
#$#

##^#---- HOST PROFILE INSTALLER (OLD) ------------------------------------------
#case "$(uname)" in
#    FreeBSD) host="$(grep 'hostname' /etc/rc.conf |
#        sed -E 's/(^.*=")(.*\.)(.*$)/\2/')" ;;
#    Linux) host="$(cat /etc/hostname)" ;;
#    OpenBSD) host="$(cat /etc/myname | cut -d '.' -f 1)" ;;
#    *) host="$(hostname)" ;;
#esac

#host_profile="${PROFILES}/${host}"
#echo hi
#while IFS= read -r file; do
#    target="${file##${host_profile}}"
#    directory="$(dirname "$target")"

#    if [ ! -d "$directory" ]; then
#        mkdir -p "$directory" 2>/dev/null || \
#            sudo mkdir -p "$directory"; fi

#    if [ -e "$target" ] && \
#        ! readlink "$target" 1>/dev/null && \
#        [ ! -f "${target}_bu" ]; then
#            mv "$target" "${target}_bu" 2>/dev/null || \
#            sudo mv "$target" "${target}_bu"; fi

#    ln -sfn "$file" "$target" 2>/dev/null || \
#        sudo cp "$file" "$target" 2>/dev/null
#done < <(find "$host_profile" -type f)
##$#

#^#---- MISCELLANEOUS ----------------------------------------------------------
# set non-retarded timeout length of 30 seconds for systemd
sudo sed -i -E '/DefaultTimeout.*Sec/ s/(^#)(.*)(90)(.*)/\230\4/' \
    /etc/systemd/system.conf

# enable pacman colors
grep 'ILoveCandy' /etc/pacman.conf ||
    sudo sed -i '/^# Misc options/a Color\nILoveCandy' /etc/pacman.conf

# install cht.sh
curl "https://cht.sh/:cht.sh" | sudo tee /usr/local/bin/cht.sh
sudo chmod +x /usr/local/bin/cht.sh
#$#

fi

# vim: ft=sh fdm=marker fmr=#^#,#$#
