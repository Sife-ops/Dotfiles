#!/bin/sh
# bookmarks manager using sqlite3

self=$(basename "${0##/*/}")

dataDir="${XDG_DATA_HOME}/bookmarks"
dbName="bookmarks.db"
db="${dataDir}/${dbName}"

config="${XDG_CONFIG_HOME}/bookmarks/bookmarksrc"
while IFS="" read -r line; do
    eval "$line"
done < "$config"

# createDb () { #^
# } #$

download () { #^
    pushd "$dataDir"
    eval "$fetchCmd" &&
        notify-send "$self" "Download successful." ||
        notify-send "$self" "Download failed."
    tar xf "${dbName}.tar.xz"
    popd
} #$

upload () { #^
    pushd "$dataDir"
    tar caf ${dbName}.tar.xz  ${dbName}
    eval "$pushCmd" &&
        notify-send "$self" "Upload successful." ||
        notify-send "$self" "Upload failed."
    popd
} #$

tags_list () { #^
    sqlite3 "$db" "SELECT name
        FROM sqlite_master
        WHERE type = 'table'
        AND name
        NOT LIKE 'sqlite_%'
        AND name
        NOT LIKE 'bookmark';"
} #$

main_list () { #^
    # echo "==== Actions ==================================================================================================================================================================================================================================================================================================================================================================================================="
    echo "create bookmark"
    echo "create tag"
    echo "download"
    echo "upload"
    echo "==== Tags ======================================================================================================================================================================================================================================================================================================================================================================================================"
    tags_list | sort
    echo "==== All ======================================================================================================================================================================================================================================================================================================================================================================================================="
    sqlite3 "$db" "SELECT description,url
        FROM bookmark;"
    echo "sqlitebrowser"
} #$

action_list () { #^
    echo "open in browser"
    echo "open with url.sh"
    [ -n "$1" ] && echo "remove tag" || echo "add tag"
    echo "delete"
} #$

filter_list () { #^
    # echo "open all in browser"
    # echo "================================================================================================================================================================================================================================================================================================================================================================================================================"
    sqlite3 "$db" "SELECT description,url,bookmarkId
        FROM bookmark
        WHERE bookmarkId
        IN (SELECT bookmarkId FROM '${tag}');"
    echo "================================================================================================================================================================================================================================================================================================================================================================================================================"
    echo "delete tag"
} #$

create_tag () { #^
    # tag name -> $1
    sqlite3 "$db" "CREATE TABLE '${tag}' (
        '${tag}Id'	INTEGER NOT NULL UNIQUE,
        'bookmarkId'	INTEGER NOT NULL UNIQUE,
        PRIMARY KEY('${tag}Id' AUTOINCREMENT),
        FOREIGN KEY('bookmarkId') REFERENCES 'bookmark'('bookmarkId') ON DELETE CASCADE
    );"
} #$

delete_tag () { #^
    sqlite3 "$db" "drop table '${tag}';"
} #$

add_tag () { #^
    sqlite3 "$db" "INSERT INTO '${tag}' (bookmarkId)
    VALUES ((SELECT bookmarkId
        FROM bookmark
        WHERE url = '${url}'));"
} #$

remove_tag () { #^
    sqlite3 "$db" "DELETE FROM '${tag}'
        WHERE bookmarkId = '${bookmarkId}';"
} #$

delete_bookmark () { #^
    sqlite3 "$db" "DELETE FROM bookmark
    WHERE url = '${url}';"
} #$

create_bookmark () { #^ #^
    url="$(xclip -o -selection clipboard)"

    tmp=$(mktemp /tmp/bookmarks_XXXXX)
    curl -L "$url" -o "$tmp"
    description="$(egrep -o '<title>.*</title>' "$tmp" | head -n 1)"
    description="$(echo "$description" | sed -E 's/(<title>)(.*)(<\/title>)/\2/')"
    description="$(echo "$description" | sed 's/|/:/')"
    rm "$tmp"

    tmp=$(mktemp /tmp/bookmarks_XXXXX)
    echo "{
        \"url\":\"${url}\",
        \"description\":\"${description}\",
        \"tags\": [
            \"<++>\",
            \"<++>\"
        ]
    }" | jq "." > "$tmp"

    $TERMEXEC $EDITOR "$tmp"
    jq '.' "$tmp" || kill 0
    # while ! cat "$tmp" | jq; do
    #     $TERMEXEC $EDITOR "$tmp"
    # done

    url="$(jq -r '.url' "$tmp")"
    description="$(jq -r '.description' "$tmp")"
    rating="$(jq -r '.rating' "$tmp")"

    [ "$url" = "null" ] || \
        [ "$description" = "null" ] && \
        kill 0

    sqlite3 "$db" \
        "INSERT INTO bookmark (url, description)
        VALUES ('${url}', '${description}');"

    if jq -r 'has("tags")' "$tmp"; then
        bookmarkId=$(sqlite3 "$db" \
            "SELECT bookmarkId
            FROM bookmark
            WHERE url = '$url';")
        jq -r '.tags[]' "$tmp" |
            while IFS="" read -r tag; do
                tag="#${tag}"
                sqlite3 "$db" \
                    "INSERT INTO '${tag}' (bookmarkId)
                    VALUES ($bookmarkId);"
            done
    fi
    rm "$tmp"
} #$

url_menu () { #^
    case "$chosen" in
        "open in browser") $BROWSER "$url" ;;
        "open with url.sh") url.sh "$url" ;;
        "add tag") tag="$(tags_list | ${DMENU_CMD:-dmenu})"; [ "$tag" = "" ] && exit 1
            add_tag ;;
        "remove tag") remove_tag ;;
        delete) delete_bookmark ;;
    esac
} #$

confirm () { #^
    printf "yes\nno" |
        ${DMENU_CMD:-dmenu} -p "Are you sure?" |
        grep 'yes' 1>/dev/null 2>&1 &&
            true ||
            false
} #$

[ -f "$db" ] || download
if [ ! -f "$db" ]; then
    notify-send "${0##/*/}" "failed to download database"
    exit 1
fi

chosen="$(main_list | ${DMENU_CMD:-dmenu})"; [ "$chosen" = "" ] && exit 1
case "$chosen" in
    "create bookmark") create_bookmark ;;
    "create tag")   tag="$(printf "" |
                        ${DMENU_CMD:-dmenu} -p "tag name" |
                        sed -E 's/(.*)/#\1/')"
                    create_tag ;;
    sqlitebrowser) sqlitebrowser "$db" & ;;
    upload) confirm && upload ;;
    download) confirm && download ;;
    '#'*)   tag="$chosen"
            chosen="$(filter_list | ${DMENU_CMD:-dmenu})"; [ "$chosen" = "" ] && exit 1
            case "$chosen" in
                # "open all in browser") delete_tag ;;
                "delete tag") delete_tag ;;
                *)  url="$(echo "$chosen" | cut -d '|' -f 2)"
                    bookmarkId="$(echo "$chosen" | cut -d '|' -f 3)"
                    chosen="$(action_list t | ${DMENU_CMD:-dmenu})"; [ "$chosen" = "" ] && exit 1
                    url_menu ;;
            esac ;;
    *)  url="$(echo "$chosen" | cut -d '|' -f 2)"
        chosen="$(action_list | ${DMENU_CMD:-dmenu})"; [ "$chosen" = "" ] && exit 1
        url_menu ;;
esac

#^ The Categorization Script:
##!/bin/bash

#db="./bookmarks.db"

#tags="$(

#        sqlite3 "$db" "SELECT name
#            FROM sqlite_master
#            WHERE type = 'table'
#            AND name
#            NOT LIKE 'sqlite_%'
#            AND name
#            NOT LIKE 'bookmark';" | nl

#)"

#while IFS="|" read a url c; do
#    # url="$(echo "$url" | tr -d '[:space:]')" # breaks everything
#    while true; do
#        echo "$tags"
#        echo "=============================================================================="
#        echo "${url}"
#        echo "$c"
#        read -p "n:next " act </dev/tty
#        case "$act" in
#            n) break ;;
#            *)  tag="$(echo "$tags" | sed -n "${act}p" | awk '{print $2}')"
#                sqlite3 "$db" "INSERT INTO '${tag}' (bookmarkId)
#                VALUES ((SELECT bookmarkId
#                    FROM bookmark
#                    WHERE url = '${url}'));" ;;
#        esac
#    done
#done < <(sqlite3 "$db" "select * from bookmark;")
#$

# vim: fdm=marker fmr=#^,#$
