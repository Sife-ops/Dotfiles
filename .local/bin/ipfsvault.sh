#!/bin/sh
# ipfs library

ipfs_vault_hash="${IPFS_VAULT_HASH:-$HOME/.cache/ipfs-vault-hash}"
if [ ! -f "$ipfs_vault_hash" ]; then
    printf 'Error: %s not found.\n' "$ipfs_vault_hash"
    exit 1
fi

ipfs_vault_hash(){ #^
    cat "$ipfs_vault_hash"
} #$

vault(){ #^
    curl https://ipfs.io/ipfs/"$(cat "$ipfs_vault_hash")" 2>/dev/null |
        gpg --quiet --output - --decrypt
} #$
