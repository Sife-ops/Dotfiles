#!/bin/sh

dataDir="${XDG_DATA_HOME}/movies"
dbRoot="/mnt/wyatt/russianbot/shared/default/home/wyatt/.local/share/games/Video/Movies"
dbName="movies.db"
db="${dataDir}/${dbName}"

createDb () { #^
    sqlite3 "$db" ".databases"

    # director table
    sqlite3 "$db" \
        "CREATE TABLE 'director' (
        'directorId'	INTEGER NOT NULL UNIQUE,
        'name'	TEXT NOT NULL,
        'country'   TEXT,
        'yob'	INTEGER,
        'rating'   NUMERIC,
        PRIMARY KEY('directorId' AUTOINCREMENT)
    );"

    # movie table
    sqlite3 "$db" \
        "CREATE TABLE 'movie' (
        'movieId'	INTEGER NOT NULL UNIQUE,
        'directorId'	INTEGER,
        'title'	TEXT NOT NULL,
        'year'	INTEGER NOT NULL,
        'rating'	NUMERIC,
        'path'	TEXT NOT NULL,
        PRIMARY KEY('movieId' AUTOINCREMENT),
        FOREIGN KEY('directorId') REFERENCES 'director'('directorId') ON DELETE CASCADE
    );"

    # # genre table
    # sqlite3 "$db" \
    #     "CREATE TABLE 'space' (
    #     'spaceId'	INTEGER NOT NULL UNIQUE,
    #     'movieId'	INTEGER NOT NULL,
    #     PRIMARY KEY('spaceId' AUTOINCREMENT),
    #     FOREIGN KEY('movieId') REFERENCES 'movie'('movieId') ON DELETE CASCADE
    # );"

    find "$dbRoot" -type f \
        -iregex '^.*\.mp4$' -or \
        -iregex '^.*\.mkv$' -or \
        -iregex '^.*\.flv$' -or \
        -iregex '^.*\.avi$' | while IFS="" read -r _path_; do
            _path_="${_path_##*/Movies/}"
            tmp="$(basename "$(dirname "$_path_")")"
            title="$(echo "$tmp" | sed -E 's/(^.*)( \([0-9]{4}\).*$)/\1/')"
            year="$(echo "$tmp" | sed -E 's/(^.*\()([0-9]{4})(\).*$)/\2/')"
            sqlite3 "$db" "INSERT INTO movie (title,year,path)
                VALUES (\"${title}\", ${year}, \"${_path_}\");"
    done

} #$

_help_ () { #^

    echo "                      _                 _     "
    echo " _ __ ___   _____   _(_) ___  ___   ___| |__  "
    echo "| '_ \` _ \ / _ \ \ / / |/ _ \/ __| / __| '_ \ "
    echo "| | | | | | (_) \ V /| |  __/\__ \_\__ \ | | |"
    echo "|_| |_| |_|\___/ \_/ |_|\___||___(_)___/_| |_|"
    echo
    echo commands:
    echo "  newDirector NAME [COUNTRY] [YOB] [RATING]"
    echo "  newGenre NAME"
}
alias help='_help_' #$

newDirector () { #^
    if [ -z "$2" ]; then
        sqlite3 "$db" \
            "INSERT INTO director (name)
                    VALUES (\"${1}\");"
    elif [ -z "$3" ]; then
        sqlite3 "$db" \
            "INSERT INTO director (name, country)
                VALUES (\"${1}\", \"${2}\");"
    elif [ -z "$4" ]; then
        sqlite3 "$db" \
            "INSERT INTO director (name, country, yob)
                VALUES (\"${1}\", \"${2}\", ${3});"
    else
        sqlite3 "$db" \
            "INSERT INTO director (name, country, yob, rating)
                VALUES (\"${1}\", \"${2}\", ${3}, ${4});"
    fi
} #$

newGenre () { #^
    # genre table
    sqlite3 "$db" \
        "CREATE TABLE '${1}' (
        '${1}Id'	INTEGER NOT NULL UNIQUE,
        'movieId'	INTEGER NOT NULL,
        PRIMARY KEY('${1}Id' AUTOINCREMENT),
        FOREIGN KEY('movieId') REFERENCES 'movie'('movieId') ON DELETE CASCADE
    );"
} #$

showDecade () { #^
sqlite3 "$db" \
    "select year,title,movieId from movie
    where year between $1 and $(($1 + 9));" |
        sort -g
} #$

playMovie () { #^
    _path_="$(sqlite3 "$db" \
        "select path from movie
        where movieId = $1;")"
    mpv "${dbRoot}/${_path_}"
} #$

clear
help

#^ zombiecode
# # example data
# sqlite3 "$db" \
#     "insert into year (yearId)
#     values (1977);"

# data creation #^
# while IFS="|" read a b; do
#     title="$a"
#     path="$b"
#     # echo $path
#     sqlite3 "$db" "INSERT INTO movie (title,path)
#     VALUES (\"$title\",\"$path\");"
# done < "./raw01"

# while IFS="|" read a b; do
#     year=$(echo "$b" | sed -E 's/^(.*)(\()([0-9]{4})(\))(.*)$/\3/')
#     echo "${year}|${a}|${b}"
# done < "./raw01" > "./raw02"

# while IFS="|" read year title path; do
#     sqlite3 "$db" "INSERT INTO movie (yearId,title,path)
#     VALUES (${year},\"${title}\",\"${path}\");"
# done < "./raw02"

#$

# # year table
# sqlite3 "$db" \
#     "CREATE TABLE 'year' (
#     'yearId'	INTEGER NOT NULL UNIQUE,
#     'rating'	NUMERIC,
#     PRIMARY KEY('yearId')
# );"


# # # update record
# sqlite3 "$db" \
#     "update movie
#     set yearId = 1977
#     where title = 'Star Wars';"


# # alter table
# sqlite3 "$db" \
#     "alter table movie
#     add column 'yearId' integer;"


# # example data
# sqlite3 "$db" \
#     "insert into director (name,country)
#     values ('Quentin Tarantino', 'United States of America');"


# # example data
# sqlite3 "$db" \
#     "insert into 'space' (movieId)
#     values ((select movieId
#         from movie
#         where title = 'Star Wars'));"


# relateAToB () {
#     sqlite3 "$db" \
#         "INSERT INTO '$2' (movieId)
#         VALUES ((SELECT movieId
#                 FROM movie
#                 WHERE title=\"$1\"));"
# }
#$

# vim: fdm=marker fmr=#^,#$
