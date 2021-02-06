#!/bin/sh

if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh gh gpg jq || exit 1; fi

#^ setup
url_file="${GHVAULT_URL:-${HOME}/.cache/ghvault-url}"
if [ -f "$url_file" ]; then
    url="$(cat "$url_file")"
else
    printf 'Error: cannot read %s.\n' "$url_file"
    exit 1
fi
if [ -z "$GHVAULT_GPG_ID" ]; then
    printf "Error: GHVAULT_GPG_ID must be set.\n"
    exit 1
fi
cache="${GHVAULT_CACHE:-$HOME/.cache/ghvault-cache.asc}"
#$

ghvault_login(){ #^
    if gh auth status 2>/dev/null; then
        :
    else
        gpg --quiet --decrypt "${GNUPGHOME}/ghvault.gpg" |
            gh auth login --with-token -
    fi
} #$

sync(){ #^
    ghvault_login
    curl "$url" 2>/dev/null > "$cache"
} #$

vault(){ #^
    if [ -f "$cache" ]; then
        gpg --quiet --output - --decrypt "$cache"
    else
        sync
        gpg --quiet --output - --decrypt "$cache"
    fi
} #$

# vim: fdm=marker fmr=#^,#$
