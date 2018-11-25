#!/bin/bash

echo Checking $1
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
TEMP_DIR=temp
KEYS_URL=https://pastebin.com/raw/GQesC1bj
KEYS=keys.txt
FILE_EXTENSION="${1##*.}"
CHECK_LOG=check.log
BASE_NAME=$(basename "$1")

pushd $SCRIPT_DIR &> /dev/null

if [ ! -f ./hactool ]; then
    echo
    echo
    echo No hactool binary found!
    echo You must place hactool binary to the script directory
    echo
    echo
    exit 1
fi

if [ ! -f $KEYS ]; then
    echo
    echo
    echo No $KEYS file found!
    echo Get your keys first! Use kezplez on Switch or google it! 
    echo
    echo
    exit 1
fi

if [ ! -d $TEMP_DIR ]; then
    echo Creating temp directory...
    mkdir $TEMP_DIR &> /dev/null
fi

if [ "$FILE_EXTENSION" = "nsp" ]; then
    echo Extracting nsp...
    ./hactool -k "$KEYS" -x --intype=pfs0 --pfs0dir=$TEMP_DIR "$1" &> /dev/null
else
    echo Extracting xci...
    ./hactool -k "$KEYS" -txci --securedir=$TEMP_DIR "$1" &> /dev/null
fi


if [ $? -eq 0 ]; then
    echo "Extracting finished!"
else
    echo
    echo ------------------------------------------------------------------------
    echo
    echo                           SOMETHING GONE WRONG!
    echo
    echo           file is not Switch game or contain forbidden symbols
    echo      rename your game file to simple name without special symbols
    echo
    echo ------------------------------------------------------------------------
    echo
    exit 1
fi

BIGGEST_FILE=`du -a $TEMP_DIR/* | sort -r -n | head -1`
BIGGEST_FILE=`set -- $BIGGEST_FILE; echo $2`
echo Biggest nca: $BIGGEST_FILE
echo Checking nca...
./hactool -k "$KEYS" -y "$BIGGEST_FILE" > $CHECK_LOG 2>/dev/null

DEFAULT_COLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
if grep -Fq "Fixed-Key Signature (GOOD)" $CHECK_LOG; then
    printf "$GREEN"
    printf "\n------------------------------------------------------------------------\n\n"
    printf "$BASE_NAME is GOOD!"
    printf "\n\n------------------------------------------------------------------------\n"
else
    printf "$RED"
    printf "\n------------------------------------------------------------------------\n\n"
    printf "$BASE_NAME is CORRUPTED!"
    printf "\n\n------------------------------------------------------------------------\n"
fi

echo -n Calculating md5...
echo -en "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
if ! type "md5sum" &> /dev/null; then
    echo MD5: $(md5 -q "$1")
else
    echo MD5: $(md5sum "$1")
fi

printf "$DEFAULT_COLOR"

echo Cleaning things up...
rm -rf $TEMP_DIR
rm $CHECK_LOG

popd &> /dev/null
