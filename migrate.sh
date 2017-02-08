#!/bin/bash -e

ROOT=$(dirname $0)

if [ "$#" -gt "2" ]; then
    echo "Usage: [<source-point> [<dest-point>]]"
    exit
fi

if [ "$#" -eq "0" ]; then
    echo -n "Going to drop entire database, is this okay? (y/n): "

    read ANSWER
    if [ "$ANSWER" != "y" ]; then exit; fi
fi

if [ "$#" -gt "0" ]; then
    SOURCE_POINT=$1
    shift
else
    SOURCE_POINT="0"
fi

if [ "$#" -gt "0" ]; then
    DEST_POINT=$1
else
    DEST_POINT=""
fi

HOST="127.0.0.1"
USERNAME="postgres"
PASSWORD=""

for migration_file in $(ls -v $ROOT/migrations); do
    MIGRATION_VERSION=$(echo $migration_file | cut -d. -f1)

    if [ -n "$DEST_POINT" ] && [ "$MIGRATION_VERSION" -gt "$DEST_POINT" ]; then break; fi

    if [ "$SOURCE_POINT" -eq "0" ] || [ "$MIGRATION_VERSION" -gt "$SOURCE_POINT" ]; then
       echo "Running migration: $migration_file"
       PGPASS=$PASSWORD psql -h $HOST -U $USERNAME < $ROOT/migrations/$migration_file >/dev/null
    fi
done
