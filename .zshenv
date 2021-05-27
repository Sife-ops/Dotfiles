#              _
#      _______| |__   ___ _ ____   __
#     |_  / __| '_ \ / _ \ '_ \ \ / /
#    _ / /\__ \ | | |  __/ | | \ V /
#   (_)___|___/_| |_|\___|_| |_|\_/

#^#---- XDG --------------------------------------------------------------------
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
#$#

#^#---- PATH -------------------------------------------------------------------
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="${PATH}:${XDG_DATA_HOME}/npm/bin"
export PATH="${PATH}:${XDG_CONFIG_HOME}/emacs/bin"
#$#

#^#---- DEFAULT PROGRAMS -------------------------------------------------------
command -v nvim >/dev/null 2>&1 \
	&& editor="nvim" \
	|| editor="vim"
export ALTEDITOR="code"
export BROWSER="${BROWSER:-lynx}"
export EDITOR="$editor"
export FCEDIT="$editor"
export PAGER="less"
export READER="zathura"
export TERMEXEC="st -e"
export TERMINAL="st"
export VISUAL="$editor"
#$#

#^#---- OTHER ------------------------------------------------------------------
# export QT_AUTO_SCREEN_SCALE_FACTOR=0
# export VIMINIT='if !has('nvim') | source "${XDG_CONFIG_HOME:-$HOME/.config}/vim/vimrc" | endif'
# export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # breaks some DMs
export ADDRESSBOOK="${XDG_DATA_HOME}/addressbook"
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME}/android"
export BOOKMARKS="${XDG_DATA_HOME}/bookmarks"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export CLIPBOARD="${XDG_DATA_HOME}/clipboard"
export CUDA_CACHE_PATH="${XDG_CACHE_HOME}/nv"
export DMENU_CMD="dmenu -i -l 20"
export DOWNLOADS="${HOME}/Downloads"
export FEEDS="${XDG_CONFIG_HOME}/newsboat/urls"
export GDBHISTFILE="${XDG_DATA_HOME}/gdb/history"
export GEM_HOME="${XDG_DATA_HOME}/gem" # remove gem: --user-install from /etc/gemrc
export GEM_SPEC_CACHE="${XDG_CACHE_HOME}/gem"
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
export GOPATH="${XDG_DATA_HOME}/go"
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc-2.0"
export HISTFILE="${XDG_DATA_HOME}/history"
export HISTSIZE=1000000
export ICEAUTHORITY="${XDG_CACHE_HOME}/ICEauthority"
export INPUTRC="${XDG_CONFIG_HOME}/inputrc"
export IRC="${XDG_DATA_HOME}/ii"
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
export LYNX_CFG="${XDG_CONFIG_HOME}/lynx/lynx.cfg"
export LYNX_CFG_PATH="${XDG_CONFIG_HOME}/lynx"
export NNN_OPTS='dH'
export NNN_PLUG='c:fzcd'
export NODE_REPL_HISTORY="${XDG_DATA_HOME}/node_repl_history"
export NOTIFICATIONS="${XDG_DATA_HOME}/notifications"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NVM_DIR="${XDG_DATA_HOME}/nvm"
export PGPASSFILE="${XDG_CONFIG_HOME}/pg/pgpass"
export PGSERVICEFILE="${XDG_CONFIG_HOME}/pg/pgservice.conf"
export PROFILES="${XDG_DATA_HOME}/profiles"
export PSQLRC="${XDG_CONFIG_HOME}/pg/psqlrc"
export PSQL_HISTORY="${XDG_CACHE_HOME}/pg/psql_history"
# export QT_QPA_PLATFORMTHEME="gtk2"
export QT_QPA_PLATFORMTHEME="qt5ct"
export SAVEHIST=900000
export SECRETS="${XDG_DATA_HOME}/secrets"
export SFX="${XDG_DATA_HOME}/sfx"
export SQLITE_HISTORY="${XDG_CACHE_HOME}/sqlite_history"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export TODO="${XDG_DATA_HOME}/todo"
export URL_OPENER="url.sh"
export WALLPAPER="${XDG_DATA_HOME}/wallpaper"
export WALLPAPERS="${XDG_DATA_HOME}/wallpapers"
export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc"
export XMODMAP="${HOME}/.Xmodmap"
export XMODMAPS="${XDG_CONFIG_HOME}/xmodmap"
export XMONAD_CACHE_HOME="${XDG_CACHE_HOME}/xmonad"
export XMONAD_CONFIG_HOME="${XDG_CONFIG_HOME}/xmonad"
export XMONAD_DATA_HOME="${XDG_DATA_HOME}/xmonad"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="${XDG_CONFIG_HOME}/java"
#$#

# vim: ft=sh fdm=marker fmr=#^#,#$#
