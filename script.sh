#!/bin/bash

lineaInclude=$(git branch | grep -n "*"|cut -d "*" -f 2|tr -d '[[:space:]]')
final=$lineaInclude | $(cut -d "*" -f 2|tr -d '[[:space:]]')
echo $lineaInclude
