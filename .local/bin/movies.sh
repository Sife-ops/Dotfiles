#!/bin/sh

_help_ () { #^
    echo "                      _                 _     "
    echo " _ __ ___   _____   _(_) ___  ___   ___| |__  "
    echo "| '_ \` _ \ / _ \ \ / / |/ _ \/ __| / __| '_ \ "
    echo "| | | | | | (_) \ V /| |  __/\__ \_\__ \ | | |"
    echo "|_| |_| |_|\___/ \_/ |_|\___||___(_)___/_| |_|"
    echo
    echo "commands:"
    echo "  createDb"
    echo "  browseDb"
    echo "  newDirector NAME [COUNTRY] [YOB] [RATING]"
    echo "  newGenre NAME"
    echo "  playMovie MOVIEID"
    echo "  listDecade YEAR"
}
alias help='_help_' #$

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

listMovies () {
    echo "title|year|movieId"
    sqlite3 "$db" \
        "SELECT title,year,movieId
        FROM movie" |
            sort
}

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

updateDirector () {
    # name -> $1, title -> $2
    sqlite3 "$db" \
        "UPDATE movie
            SET directorId = (SELECT directorId
                FROM director
                WHERE name = \"${1}\")
            WHERE title = \"${2}\";"
}

listDirectors () {
    sqlite3 "$db" \
        "SELECT *
        FROM director;"
}

updateMovieRating () {
    # title -> $1, rating -> $2
    sqlite3 "$db" \
        "UPDATE movie
        SET rating = $2
        WHERE title = \"${1}\";"
}

updateDirectorRating () {
    # title -> $1, rating -> $2
    sqlite3 "$db" \
        "UPDATE director
        SET rating = $2
        WHERE title = \"${1}\";"
}

listDirector () {
    sqlite3 "$db" \
        "SELECT title,year,rating,movieId
        FROM movie
        WHERE directorId = (SELECT directorId
            FROM director
            WHERE name = \"${1}\");"
}

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

listDecade () { #^
    echo "year|title|movieId"
    sqlite3 "$db" \
        "select year,title,movieId from movie
        where year between $1 and $(($1 + 9));" 2>/dev/null |
            sort -g
} #$

playMovie () { #^
    _path_="$(sqlite3 "$db" \
        "select path from movie
        where movieId = $1;")"
    mpv "${dbRoot}/${_path_}"
} #$

browseDb () {
    sqlitebrowser "$db" &
}

clear
help

scrape () {
    sqlite3 "$db" \
        "SELECT title
        FROM movie" |
            while IFS="" read -r title; do
                search="$(echo "$1" | tr ' ' '+' )"
                raw="$(mktemp /tmp/movies_XXXXXX)"
                curl "https://www.imdb.com/search/title/?title=${search}" > "$raw"
                parsed="$(mktemp /tmp/movies_XXXXXX)"
                python ${dataDir}/parser.py "$raw" > "$parsed"
                metascore="$(grep -B 2 -i "metascore" "$parsed" | head -n 3 |
                    head -n 1 | tr -d '[:space:]')"
                director="$(grep -A 2 -i "director" "$parsed" | head -n 3 |
                    tail -n 1)"
                echo "${title}|${director}|${metascore}"
                rm "$raw" "$parsed"
            done |  while IFS="|" read title director metascore; do
                        case "$director" in
                            "") : ;;
                            *)  newDirector "$director"
                                case "$metascore" in
                                    "") updateDirector "$director" "$title" ;;
                                    *)  updateDirector "$director" "$title"
                                        updateMovieRating "$title" "$metascore" ;;
                                esac ;;
                        esac
                    done
}

# vim: fdm=marker fmr=#^,#$
