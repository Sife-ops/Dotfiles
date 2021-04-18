#!/bin/sh
# bookmarks manager using sqlite3

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
    echo "create bookmark"
    echo "create tag"
    echo "browse"
    echo "sync"
    echo "==== Tags ======================================================================================================================================================================================================================================================================================================================================================================================================"
    tags_list | sort
    echo "================================================================================================================================================================================================================================================================================================================================================================================================================"
    sqlite3 "$db" "SELECT description,url
        FROM bookmark;"
} #$

action_list () { #^
    echo "open"
    [ -n "$1" ] && echo "remove tag" || echo "add tag"
    echo "delete"
} #$

filter_list () { #^
    echo "delete tag"
    echo "================================================================================================================================================================================================================================================================================================================================================================================================================"
    sqlite3 "$db" "SELECT description,url,bookmarkId
        FROM bookmark
        WHERE bookmarkId
        IN (SELECT bookmarkId FROM '${tag}');"
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

create_bookmark () { #^
    url="$(xclip -o -selection clipboard)"

    tmp=$(mktemp /tmp/bookmarks_XXXXX)
    curl -L "$url" -o "$tmp"
    description="$(egrep -o '<title>.*</title>' "$tmp" | head -n 1)"
    description="$(echo "$description" | sed -E 's/(<title>)(.*)(<\/title>)/\2/')"
    description="$(echo "$description" | sed 's/|/:/')"
    rm "$tmp"

    tmp=$(mktemp /tmp/bookmarks_XXXXX)
    echo "{
        \"url\":\"$url\",
        \"description\":\"$description\"
    }" | jq "." > "$tmp"

    $TERMEXEC $EDITOR "$tmp"
    while ! cat "$tmp" | jq; do
        $TERMEXEC $EDITOR "$tmp"
    done

    url="$(cat "$tmp" | jq -r '.url')"
    description="$(cat "$tmp" | jq -r '.description')"
    rating="$(cat "$tmp" | jq -r '.rating')"
    rm "$tmp"

    [ "$url" = "null" ] || \
        [ "$description" = "null" ] && \
        kill 0

    sqlite3 "$db" "INSERT INTO bookmark (url, description)
        VALUES ('${url}', '${description}');"
} #$

url_menu () { #^
    case "$chosen" in
        # open) $BROWSER "$url" ;;
        open) url.sh "$url" ;;
        'add tag') tag="$(tags_list | ${DMENU_CMD:-dmenu})"; [ "$tag" = "" ] && exit 1
            add_tag ;;
        'remove tag') remove_tag ;;
        delete)
            # echo "$url"
            delete_bookmark
            ;;
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
    "create tag")   tag="$(printf "" |
                        ${DMENU_CMD:-dmenu} -p "tag name" |
                        sed -E 's/(.*)/#\1/')"
                    create_tag ;;
    browse) sqlitebrowser "$db" & ;;
    sync) upload ;;
    '#'*)   tag="$chosen"
            chosen="$(filter_list | ${DMENU_CMD:-dmenu})"; [ "$chosen" = "" ] && exit 1
            case "$chosen" in
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

# vim: fdm=marker fmr=#^,#$
