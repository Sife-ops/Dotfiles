if [ -n "$NAME" ]; then
    case $NAME in
        Arch*|Artix*) source /usr/share/doc/pkgfile/command-not-found.zsh 2>/dev/null ;;
        Debian*|Raspbian*) source /etc/zsh_command_not_found >/dev/null 2>&1 ;;
    esac
fi
