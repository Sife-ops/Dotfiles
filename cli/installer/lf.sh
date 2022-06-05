#!/bin/sh

install_lf() {
    echo "Operating system:"
    echo "1. Linux (amd64)"
    echo "2. Intel Mac"
    echo "Choice:"
    read choice
    echo $choice

    case $choice in
        '1')
            file=lf-linux-amd64.tar.gz
        ;;
        '2')
            file=lf-darwin-amd64.tar.gz
        ;;
        *)
            return
        ;;
    esac

    tmp=$(mktemp -d)
    echo $tmp
    pushd $tmp
    curl -LO "https://github.com/gokcehan/lf/releases/download/r27/${file}"
    tar xzf ${file}
    cp lf ${HOME}/.local/bin/
    popd
}

main() {
    echo "Do you want to install lf r27? [y/n]"
    read choice
    if [ ${choice:-'n'} = 'y' ] ; then
        install_lf
    fi
    stow lf
}

main
