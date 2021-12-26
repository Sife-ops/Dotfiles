#!/bin/sh

self=$(basename "${0##/*/}")

dbDir="${XDG_DATA_HOME}/bookmarks"
# dbDir="${HOME}/.local/src/bookmarks"
dbName="bookmarks.db"
db="${dbDir}/${dbName}"

bookmarkList(){
    sqlite3 "$db" "
        select
            description,
            url,
            rating,
            bookmark_id
        from bookmark;
    "
}

bookmarkTagList(){
    sqlite3 "$db" "
        select
            b.description,
            b.url,
            b.rating,
            b.bookmark_id
        from bookmark_tag
        inner join bookmark b using (bookmark_id)
        where tag_id = (
            select tag_id from tag
            where name = '$1'
        );
    "
}

sepStr="="
sep () {
    i=0
    while [ $i -le 500 ]; do
        printf "%s" "$sepStr"
        i=$(( i + 1 ))
    done
    printf "\n"
}

tagsView(){
    echo "back"
    sep
    sqlite3 "$db" "select name from tag;"
    sep
    if [ "$tag" = "" ]; then
        bookmarkList
    else
        bookmarkTagList "$tag"
    fi
}

mainView(){
    echo "create"
    echo "tags"
    sep
    bookmarkList
}

urlView(){
    echo "open"
    echo "copy"
    echo "rate"
    echo "add tag"
    if [ "$viewPrev" = "tags" ] && [ "$tag" != "" ]; then
        echo "remove tag"
    fi
    echo "delete"
}

create(){
    url="$(xclip -o -selection clipboard)"

    tmp=$(mktemp /tmp/XXXXXX)
    curl -L "$url" -o "$tmp"
    description="$(egrep -o '<title>.*</title>' "$tmp" | head -n 1)"
    description="$(echo "$description" | sed -E 's/(<title>)(.*)(<\/title>)/\2/')"
    description="$(echo "$description" | sed 's/|/:/')"

    echo "{
        \"description\":\"${description}\",
        \"url\":\"${url}\"
    }" | jq "." > "$tmp"

    $TERMEXEC $EDITOR "$tmp"
    jq '.' "$tmp" || kill 0

    url="$(jq -r '.url' "$tmp")"
    description="$(jq -r '.description' "$tmp")"
    rating="$(jq -r '.rating' "$tmp")"

    rm "$tmp"

    if [ "$url" = "" ] || [ "$description" = "" ]; then
        kill 0
    fi

    sqlite3 "$db" "
        insert into bookmark (url, description)
        values ('${url}', '${description}');
    "
}

view="main"
viewPrev=""
tag=""
url=""
while true; do

    case "$view" in

        "main")

            chosen=$(
                mainView | dmenu -i -l 10 $DMENU_OPTS
            ); [ "$chosen" = "" ] && exit 1

            case "$chosen" in
                "create")
                    create || exit 1
                    exit
                    ;;
                "tags")
                    view="tags"
                    viewPrev="main"
                    ;;
                "="*)
                    exit 1
                    ;;
                *)
                    url=$(echo "$chosen" | cut -d '|' -f 2)
                    view="url"
                    viewPrev="main"
                    ;;
            esac

            ;;

        "tags")

            chosen=$(
                tagsView | dmenu -i -l 10 $DMENU_OPTS
            ); [ "$chosen" = "" ] && exit 1

            case "$chosen" in
                "back")
                    view="main"
                    viewPrev="tags"
                    ;;
                "#"*)
                    tag="$chosen"
                    ;;
                "="*)
                    exit 1
                    ;;
                *)
                    url=$(echo "$chosen" | cut -d '|' -f 2)
                    view="url"
                    viewPrev="tags"
                    ;;
            esac

            ;;

        "url")

            chosen=$(
                urlView | dmenu -i -l 10 $DMENU_OPTS
            ); [ "$chosen" = "" ] && exit 1

            case "$chosen" in
                "open")
                    $BROWSER $url
                    exit
                    ;;
                "copy")
                    echo "$url" | xclip -i -selection clipboard
                    exit
                    ;;
                "rate")
                    echo "rate action"
                    exit
                    ;;
                "add tag")
                    echo "add tag action"
                    exit
                    ;;
                "remove tag")
                    echo "remove tag action"
                    exit
                    ;;
                "delete")
                    echo "delete action"
                    exit
                    ;;
                *)
                    exit 1
                    ;;
            esac

            ;;

    esac

done
