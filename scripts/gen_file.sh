#!/bin/bash

#Not tested
if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Usage: $0 \"your-post-title\" "
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

FILE=../_posts/$(date -u +"%Y-%m-%d-")$1.md
echo ""
echo "- Creating $FILE"
touch $FILE

read -p "Open $FILE in atom? y/N" -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi
atom $FILE
