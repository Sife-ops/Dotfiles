#!/bin/sh
# create empty database

# db="./bookmarks.db"
# dataDir="${XDG_DATA_HOME}/bookmarks"
# db="${dataDir}/db"
# fetchCmd="scp wyatt@soyless.xyz:/home/wyatt/${db}.tar.xz ${dataDir}"
# pushCmd="scp  ${db}.tar.xz wyatt@soyless.xyz:/home/wyatt/${db}.tar.xz"

dataDir="${XDG_DATA_HOME}/bookmarks"
dbName="bookmarks"
db="${dataDir}/${dbName}"

config="${XDG_CONFIG_HOME}/bookmarks/bookmarksrc"
while IFS="" read -r line; do
    eval "$line"
done < "$config"

download () { #^
    pushd "$dataDir"
    eval "$fetchCmd"
    tar xf "${dbName}.tar.xz"
    popd
} #$

upload () { #^
    pushd "$dataDir"
    tar caf ${dbName}.tar.xz  ${dbName}
    eval "$pushCmd"
    popd
} #$

main_list () { #^
    sqlite3 "$db" "SELECT description,url
        FROM bookmark;"
    echo "create bookmark"
    echo "create tag"
    echo "tags"
    echo "sync"
} #$

action_list () { #^
    echo "open"
    [ -n "$1" ] && echo "remove tag" || echo "add tag"
    echo "delete"
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

filter_list () { #^
    sqlite3 "$db" "SELECT description,url,bookmarkId
        FROM bookmark
        WHERE bookmarkId
        IN (SELECT bookmarkId FROM ${tag});"
    echo "delete tag"
} #$

create_tag () { #^
    # tag name -> $1
    sqlite3 "$db" "CREATE TABLE '$1' (
        '${1}Id'	INTEGER NOT NULL UNIQUE,
        'bookmarkId'	INTEGER NOT NULL UNIQUE,
        PRIMARY KEY('${1}Id' AUTOINCREMENT),
        FOREIGN KEY('bookmarkId') REFERENCES 'bookmark'('bookmarkId') ON DELETE CASCADE
    );"
} #$

delete_tag () { #^
    sqlite3 "$db" "drop table ${tag};"
} #$

add_tag () { #^
    sqlite3 "$db" "INSERT INTO $tag (bookmarkId)
    VALUES ((SELECT bookmarkId
        FROM bookmark
        WHERE url = '${url}'));"
} #$

remove_tag () { #^
    sqlite3 "$db" "DELETE FROM $tag
        WHERE bookmarkId = '${bookmarkId}';"
} #$

delete_bookmark () { #^
    sqlite3 "$db" "DELETE FROM bookmark
    WHERE url = '${url}';"
} #$

create_bookmark () { #^
    template='{
        "url": "<++>",
        "description": "<++>",
        "rating": "<++>",
    }'

    tmp=$(mktemp /tmp/bookmarks_XXXXX)
    echo "$template" | jq > "$tmp"

    $TERMEXEC $EDITOR "$tmp"
    while ! cat "$tmp" | jq; do
        $TERMEXEC $EDITOR "$tmp"
    done

    url="$(cat "$tmp" | jq -r '.url')"
    description="$(cat "$tmp" | jq -r '.description')"
    rating="$(cat "$tmp" | jq -r '.rating')"
    [ "$url" = "null" ] || \
        [ "$description" = "null" ] || \
        [ "$rating" = "null" ] && \
        exit 1
    sqlite3 "$db" "INSERT INTO bookmark (url, description, rating)
        values ('${url}', '${description}', ${rating});"

    rm "$tmp"
} #$

url_menu () { #^
    case "$chosen" in
        # open) $BROWSER "$url" ;;
        open) url.sh "$url" ;;
        'add tag') tag="$(tags_list | ${DMENU_CMD:-dmenu})"; [ "$tag" = "" ] && exit 1
            add_tag ;;
        'remove tag') remove_tag ;;
        delete) delete_bookmark ;;
    esac
} #$

[ -f "$db" ] || download
if [ ! -f "$db" ]; then
    notify-send "${0##/*/}" "failed to download database"
    exit 1
fi

chosen="$(main_list | ${DMENU_CMD:-dmenu})"; [ "$chosen" = "" ] && exit 1
case "$chosen" in
    "create bookmark") create_bookmark ;;
    "create tag") create_tag "$(printf "" | ${DMENU_CMD:-dmenu} -p "tag name")" ;;
    "tags") chosen="$(tags_list | ${DMENU_CMD:-dmenu})"; [ "$chosen" = "" ] && exit 1
        tag="$chosen"
        chosen="$(filter_list | ${DMENU_CMD:-dmenu})"; [ "$chosen" = "" ] && exit 1
        case "$chosen" in
            "delete tag") delete_tag ;;
            *) url="$(echo "$chosen" | cut -d '|' -f 2)"
                bookmarkId="$(echo "$chosen" | cut -d '|' -f 3)"
                chosen="$(action_list t | ${DMENU_CMD:-dmenu})"; [ "$chosen" = "" ] && exit 1
                url_menu ;;
        esac ;;
    sync) upload ;;
    *) url="$(echo "$chosen" | cut -d '|' -f 2)"
        chosen="$(action_list | ${DMENU_CMD:-dmenu})"; [ "$chosen" = "" ] && exit 1
        url_menu ;;
esac

# vim: fdm=marker fmr=#^,#$
