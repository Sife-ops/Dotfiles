#!/bin/sh

. bwvault.sh

if systemctl --quiet --user is-active ipfs.service 1>/dev/null 2&>1; then
    :
elif systemctl --user start ipfs.service; then
    :
else
    printf 'Error: ipfs.service unavailable.\n'
fi

safe="$(mktemp -d /tmp/bw2ipfs.XXX)"
chmod 700 "$safe"

vault="${safe}/vault.asc"
touch "$vault"
truncate -s 0 "$vault"
chmod 600 "$vault"

bw_sync

vault |
    gpg --armor --recipient "$BW_GPG_ID" --output - --encrypt > "$vault"

ipfs add "$vault" 2>/dev/null |
    cut -d ' ' -f 2 > "${IPFS_VAULT_HASH:-$HOME/.cache/ipfs-vault-hash}"

rm -rf "$safe"
