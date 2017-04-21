#!/bin/bash
salida=$(grep -e 'path = ../.gitconfig' .git/config|wc -l)	
if [ $salida -eq 0 ]; then
    echo "$salida"
else
    echo "fewfwef"
fi
