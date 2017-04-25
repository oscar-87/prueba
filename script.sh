#!/bin/bash

source gitutil_common.sh

lista_prov=""
lista_def=""
   if [ $(git config  --get pullall.default)=="" ];then
       lista_blanca=$(load_white_list pullall)
       lista_negra=$(load_black_list pullall)
       brname=$(git branch -r| grep -v "HEAD"|cut -d "/" -f1)
       if [ "$lista_blanca" = "" ] && [ "$lista_negra" = "" ]; then
	    echo "No existe ninguna lista"
       elif [ "$lista_blanca" != "" ] && [ "$lista_negra" != "" ]; then
	    b=1
	    n=1
	    blanca=$(echo $lista_blanca| cut -d "," -f$b)
	    negra=$(echo $lista_negra| cut -d "," -f$n)
	    while [ "$blanca" != "" ]; do
		    encontrada=0
		    while [ "$negra" != "" ] && [ $encontrada -eq 0 ]; do
			   if [ "$blanca" = "$negra" ]; then
				encontrada=1
			   fi
			   ((n++))
			   negra=$(echo $lista_negra| cut -d "," -f$n)
		    done
		    if [ $encontrada -eq 0 ]; then
		    	lista_def+=" $blanca"
		    fi
		    ((b++))
		    blanca=$(echo $lista_blanca| cut -d "," -f$b)
	    done
	    
       elif [ "$lista_blanca"!="" && "$lista_negra"="" ]; then
		echo "entra"
	     lista_def=$lista_blanca
       elif [ "$lista_negra"!="" $lista_blanca="" ]; then
	echo "entra 2"
	     for rama in `git branch -r  | grep -v HEAD|cut -d "/" -f2`; do
		     i=1
		     final=$(echo $lista_negra| cut -d "," -f$i)
		     while [ "$rama" != $final ]; do
			     lista_def=" $rama"
			     ((i++))
			     final=$(echo $lista_negra| cut -d "," -f$i)
		     done
	     done
	fi
   else
	echo "entra 3"
       $(git config  --get pullall.default)
   fi

echo $lista_def
