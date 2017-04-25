#!/bin/bash

source gitutil_common.sh

lista_def=""
   if [ $(git config  --get pullall.default)=="" ];then
       lista_blanca=$(load_white_list pullall)
       lista_negra=$(load_black_list pullall)
       if [ "$lista_blanca" = "" ] && [ "$lista_negra" = "" ]; then
	   update_all_branchs
	   exit 1
       elif [ "$lista_blanca" != "" ] && [ "$lista_negra" != "" ]; then
	    b=1
	    blanca=$(echo $lista_blanca| cut -d "," -f$b)
	    while [ "$blanca" != "" ]; do
		    n=1
		    negra=$(echo $lista_negra| cut -d "," -f$n)
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
	     lista_def=$lista_blanca
       elif [ "$lista_negra"!="" $lista_blanca="" ]; then
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
	echo $lista_def
	#update_branchs pullall $lista_def
   else
       $(git config  --get pullall.default)
   fi
