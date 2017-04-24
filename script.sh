#!/bin/bash
lineaInclude=$(git config  --get pull.default)
if [ $(git config  --get pull.default) != " " ] ; then
  echo "existe"
else
  echo "No existe"
fi
