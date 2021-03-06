#!/bin/bash

function usage
{
    echo "assemble-songs.sh - Assembles the pieces of each song in"
    echo "the Grand Theft Auto - San Andreas soundtrack into full"
    echo "songs, without any DJ chatter."
    echo ""
    echo "Usage: $0 <dir> [--delete]"
    echo ""
    echo "Where dir is the top-level directory containing all radio"
    echo "stations extracted by Radio Free San Andreas (i.e. the same"
    echo "as the second to last argument to extract)."
    echo "If --delete is specified, delete the partial songs and DJ"
    echo "chatter after assembly, leaving only the full songs."
    exit 1
}

if [ $# -eq 0 -o $# -gt 2 ]
then
    usage
    exit 1
fi

if [ ! -d "$1" ]
then
    echo "No such directory: $1"
    echo ""
    usage
    exit 2
fi

DELETE=0
if [ $# -eq 2 ]
then
    if [ "$2" = "--delete" ]
    then
        DELETE=1
    else
        usage
        exit 1
    fi
fi

cd "$1"

for station in *
do
    echo "Processing station $station..."
    pushd "$station" > /dev/null
    for file in *.ogg
    do
        base="`basename "$file" .ogg`"
        if [ -f "$base (Intro).ogg" -a -f "$base (Outro).ogg" ]
        then
            echo "Assembling song $base"
            cat "$base (Intro).ogg" "$base.ogg" "$base (Outro).ogg" > "$base (Complete).ogg"
            if [ $DELETE -eq 1 ]
            then
                echo "Deleting leftover parts of song $base"
                rm -f "$base"\ \(Intro*\).ogg "$base.ogg" "$base"\ \(Outro*\).ogg
            fi
        fi
    done
    popd > /dev/null
done
