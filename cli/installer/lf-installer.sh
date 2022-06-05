#!/bin/sh

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
        echo 'bad choice'
        exit
    ;;
esac

tmp=$(mktemp -d)
echo $tmp
pushd $tmp
curl -LO "https://github.com/gokcehan/lf/releases/download/r27/${file}"
tar xzf ${file}
cp lf ${HOME}/.local/bin/
popd

