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
export PATH="${PATH}:${HOME}/.deno/bin"
#$#

#^#---- EDITOR -----------------------------------------------------------------
command -v nvim >/dev/null 2>&1 \
	&& editor="nvim" \
	|| editor="vim"
export ALTEDITOR="code"
export EDITOR="$editor"
export FCEDIT="$editor"
export PAGER="less"
export VISUAL="$editor"
unset editor
#$#

#^#---- SHELL ------------------------------------------------------------------
export HISTFILE="${XDG_DATA_HOME}/history"
export HISTSIZE=1000000
export KEYTIMEOUT=1
export LESSHISTFILE="-"
export SAVEHIST=900000
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
#$#

# vim: ft=sh fdm=marker fmr=#^#,#$#
