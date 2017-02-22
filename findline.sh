#!/bin/bash

function extension()
{
    #Only care about these types of files
    case "$(basename "$@")" in
	*.c | *.cpp | *.h | *.txt | makefile | *.bat | *.py | .html | .java ) return 0;;
	*.C | *.CPP | *.H | *.TXT | Makefile | *.BAT | *.PY | .HTML | .JAVA ) return 0;;
	*.svn-base ) return 1;; #Skip SVN files
	\#* | \.* ) return 1;; #Skip hidden files
	*) [ "$fileTypes" == "all" ] && return 0 || return 1;;
    esac
}

function printheader()
{
    path="$1"
    file="$2"
    count="$3"

    #Make bars that fill console width
    width=$(tput cols)
    length=$(echo "$file" | wc -m)
    barwidth=$(($width-$length -2))
    bar=""

    until [ $barwidth -lt 1 ]; do
	bar="$bar""="
	let barwidth-=2
    done

    printf "%s \033[01m%s\033[0m %s" "$bar" "$file" "$bar"
    #Compensate for odd/even file name lengths
    [ "$(($length % 2))" -eq "0" ] && printf "=\n" || printf "\n"
    printf "path: %s\n" "$path"
    printf "matched lines: %s\n\n" "$count"
}

function grepme()
{
    key="$@"
    while read path; do
	[ -e "$path" ] || continue #Only get files that exist
	[ -d "$path" ] && continue #Skip directories
	extension "$path" || continue #Only look at types we care about
	count=$(grep -c "$key" "$path")
	if
	    [ "$count" -gt 0 ]
	then
	    file="$(basename $path)"
	    printheader "$path" "$file" "$count"
	    grep -nr "$key" "$path"
	    printf "\n\n"
	fi
    done
}

#Interpret options
fileTypes=""
startPath="."
searchTerm=""
while true; do
    case "$1" in
	-a) fileTypes=all;;#Search all file types
	*)  if
	        [ -d "$1" ]
	    then
                startPath="$1"  #If directory/location use as search location
	    else
	        searchTerm="$@" #if anything else, use as search term
	        break
	    fi;;
    esac
    shift
    [ -z "$1" ] && break
done

#Print main header
printf "\nSearching \033[01m'%s'\033[0m for term(s):  \033[01m'%s'\033[0m\n\n" "$startPath" "$searchTerm"

#Find files recusively
find "$startPath" | grepme "$searchTerm"
