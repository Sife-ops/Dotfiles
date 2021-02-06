#!/bin/sh

. bwvault.sh

if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh gh || exit 1; fi

url_file="${GHVAULT_URL:-$HOME/.cache/ghvault-url}"
cache="${GHVAULT_CACHE:-$HOME/.cache/ghvault-cache.asc}"

bw_sync

vault |
    gpg \
        --armor \
        --recipient "$GHVAULT_GPG_ID" \
        --output - \
        --encrypt |
        gh gist create \
            --public=true \
            --desc="ghv$(date +%s)" \
            --filename="ghv$(date +%s).asc" 2>/dev/null |
            sed -E -e 's/(^.*)(github)(.*$)/\1githubusercontent\3/' \
                   -e 's/(^.*.com\/)(.*$)/\1Sife-ops\/\2/' \
                   -e 's/(^.*$)/\1\/raw/' \
                   > "$url_file" && rm -rf "$cache" 2>/dev/null
