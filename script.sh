#!/bin/bash
lineaInclude=""
ll="Hola "
pp="que tal"
for i in `git branch -r| grep -v HEAD|cut -d "/" -f 2`; do
   echo $i
   lineaInclude+="$i "
done

echo $lineaInclude
