#                            __ _ _
#       _____ __  _ __ ___  / _(_) | ___
#      |_  / '_ \| '__/ _ \| |_| | |/ _ \
#     _ / /| |_) | | | (_) |  _| | |  __/
#    (_)___| .__/|_|  \___/|_| |_|_|\___|
#          |_|

#^#---- ENVIRONMENT VARIABLES --------------------------------------------------

#^#---- XDG --------------------------------------------------------------------
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
#$#

#^#---- PATH -------------------------------------------------------------------
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="${PATH}:${XDG_DATA_HOME:-${HOME}/.local/share}/npm/bin"
#$#

#^#---- DEFAULT PROGRAMS -------------------------------------------------------
command -v nvim >/dev/null 2>&1 \
	&& editor="nvim" \
	|| editor="vim"
systemctl --quiet --user is-active emacs.service >/dev/null \
    && alteditor="emacsclient" \
    || alteditor="emacs"
export ALTEDITOR="$alteditor"
export EDITOR="$editor"
export VISUAL="$editor"
export FCEDIT="$editor"
export TERMINAL="st"
export BROWSER="lynx"
export PAGER="less"
export READER="zathura"
#$#

#^#---- BITWARDEN --------------------------------------------------------------
export BW_GPG_ID="E4D903D4A2A85226E14AE435A744F927AD7099AC"
export BW_SESSION_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/bw-session.gpg"
[ -f "$BW_SESSION_CACHE" ] && rm -f "$BW_SESSION_CACHE"
#$#

#^#---- IPFS VUALT -------------------------------------------------------------
export IPFS_VAULT_GPG_ID="E4D903D4A2A85226E14AE435A744F927AD7099AC"
export IPFS_VAULT_HASH="${XDG_CACHE_HOME:-$HOME/.cache}/ipfs-vault-hash"
#$#

#^#---- OTHER ------------------------------------------------------------------
export ADDRESS_BOOK="${XDG_DATA_HOME:-$HOME/.local/share}/addressbook"
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"
export BOOKMARKS="${XDG_DATA_HOME:-$HOME/.local/share}/bookmarks"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export CLIPBOARD="${XDG_DATA_HOME:-${HOME}/.local/share}/clipboard"
export CLIPBOARD_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/clipboard.d"
export FEEDS="${XDG_CONFIG_HOME:-$HOME/.config}/newsboat/urls"
export GEM_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/gem" # remove gem: --user-install from /etc/gemrc
export GEM_SPEC_CACHE="${XDG_CACHE_HOME:-${HOME}/.cache}/gem"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export GNUPGHOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"
export HISTSIZE=1000000
export ICEAUTHORITY="${XDG_CACHE_HOME:-$HOME/.cache}/ICEauthority"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/inputrc"
export IRC="${XDG_DATA_HOME:-$HOME/.local/share}/irc"
export KEYTIMEOUT=1
export LESSHISTFILE="-"
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';
export LYNX_CFG="${XDG_CONFIG_HOME:-$HOME/.config}/lynx/lynx.cfg"
export LYNX_CFG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/lynx"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npmrc"
export NNN_OPTS='dH'
export NNN_PLUG='c:fzcd'
export NOTIFICATIONS="${XDG_DATA_HOME:-$HOME/.local/share}/notifications"
export NVM_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvm"
export QT_QPA_PLATFORMTHEME="gtk2"
# export QT_AUTO_SCREEN_SCALE_FACTOR=0
export SARBS="${XDG_DATA_HOME:-$HOME/.local/share}/sarbs"
export SAVEHIST=900000
export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export URL_OPENER="fzfurl.sh"
# export VIMINIT='if !has('nvim') | source "${XDG_CONFIG_HOME:-$HOME/.config}/vim/vimrc" | endif'
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
# export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # breaks some DMs
export XMONAD_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}/xmonad"
export XMONAD_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/xmonad"
export XMONAD_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/xmonad"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
# export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="${XDG_CONFIG_HOME:-$HOME/.config}/java"
#$# #$#

#^#---- CLIPBOARD --------------------------------------------------------------
mkdir -p $CLIPBOARD_DIR
touch $CLIPBOARD_DIR/0{0,1,2,3,4}
touch $CLIPBOARD
chmod 700 ${CLIPBOARD_DIR}
chmod 600 ${CLIPBOARD_DIR}/*
chmod 600 $CLIPBOARD
#$#

#^#---- HOST PROFILE -----------------------------------------------------------
profiles=$SARBS/profiles
default_profile=$profiles/default
host=$(cat /etc/hostname)
host_profile=$profiles/$host
function install_profile(){
    for file in $(find $1 -type f)
    do
        ln -sf "$file" "${HOME}/${file##${1}/}"
    done
}
install_profile $default_profile
install_profile $host_profile
#$#

#^#---- NOTIFICATIONS ----------------------------------------------------------
mkdir -p $(dirname $NOTIFICATIONS)
touch $NOTIFICATIONS
chmod 600 $NOTIFICATIONS
#$#

#^#---- OMISU ------------------------------------------------------------------
# (which omisu >/dev/null 2>&1 && \
# ! pgrep -x omisu >/dev/null 2>&1) && \
    # omisu &
#$#

#^#---- TIRAMISU ---------------------------------------------------------------
# (which tiramisu >/dev/null 2>&1 && \
# ! pgrep -x tiramisu >/dev/null 2>&1) && \
#     tiramisu -j >> $NOTIFICATIONS &
#$#

#^#---- VCONSOLE ---------------------------------------------------------------
# sudo -n loadkeys ${SARBS}/ttymaps.kmap 2>/dev/null
#$#

# vim: fdm=marker fmr=#^#,#$#
