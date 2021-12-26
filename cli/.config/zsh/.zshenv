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
#export PATH="${PATH}:${XDG_DATA_HOME}/npm/bin"
#export PATH="${PATH}:${XDG_DATA_HOME}/solana/install/active_release/bin"
#$#

#^#---- DEFAULT PROGRAMS -------------------------------------------------------
command -v nvim >/dev/null 2>&1 \
	&& editor="nvim" \
	|| editor="vim"
export ALTEDITOR="code"
#export BROWSER="chromium"
export EDITOR="$editor"
export FCEDIT="$editor"
export PAGER="less"
#export READER="zathura"
#export TERMEXEC="st -e"
#export TERMINAL="st"
export VISUAL="$editor"
unset editor
#$#

#^#---- OPTIONS ----------------------------------------------------------------
export DMENU_OPTS="-i -l 20"
export HISTFILE="${XDG_DATA_HOME}/history"
export HISTSIZE=1000000
export KEYTIMEOUT=1
export LESSHISTFILE="-"
#export NVM_DIR="${XDG_DATA_HOME}/nvm"
#export QT_QPA_PLATFORMTHEME="qt5ct"
export SAVEHIST=900000
#export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export TODO="${XDG_DATA_HOME}/todo"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
#$#

# vim: ft=sh fdm=marker fmr=#^#,#$#
