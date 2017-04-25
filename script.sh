#!/bin/bash

function load_white_list(){
  ramas=""
  if [ $(git config --get pullall.lista.blanca)!="" ]; then
     ramas=$(git config --get pullall.lista.blanca)
fi
  echo $ramas

}

a=$(load_white_list)

echo $a

