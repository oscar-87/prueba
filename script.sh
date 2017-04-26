#!/bin/bash

function load_white_list(){
  ramas=""
  if [ $(git config --get $1.lista.blanca)!="" ]; then
    ramas=$(git config --get $1.lista.blanca)
  fi
  echo $ramas

}

function load_black_list(){
  ramas=""
  if [ $(git config --get $1.lista.negra)!="" ]; then
    ramas=$(git config --get $1.lista.negra)
  fi
  echo $ramas

}

function update_all_branchs(){
    echo "Updating all branchs from remote..."
    git remote update --prune

    #Pull from all remote branches
    for brname in `git branch -r  | grep -v HEAD `; do
        echo "Updating ${brname/\// }..."
        CBRANCH=`echo $brname | sed -e 's/.*\///g'`
        git checkout $CBRANCH
        git pull ${brname/\// } 
    done
    
    git checkout $BRANCH
}
function update_branchs(){
echo $1 $2 $3 $4

   if [ "$1" = "pullall" ]; then
      for brname in `git branch -r  | grep -v HEAD `; do
	  CBRANCH=`echo $brname | sed -e 's/.*\///g'`
	  echo $CBRANCH
	  i=2
   	  #while [ $i -lt $# ]; do
	  for i in "$@"; do
		echo "entra $CBRANCH $i $#"
		if [ "$CBRANCH" == "$i" ]; then
            	     echo "Pulling from ${brname/\// }..."
	    	     git checkout $CBRANCH
	    	     git pull $brname $i
		fi
		((i++))
    	  done
      done
   fi
}
lista_def[0]=""
 declare -a blanca
   if [ $(git config  --get pullall.default)=="" ];then
       lista_blanca=$(load_white_list pullall)
       lista_negra=$(load_black_list pullall)
       if [ "$lista_blanca" = "" ] && [ "$lista_negra" = "" ]; then
	   update_all_branchs
	   exit 1
       elif [ "$lista_blanca" != "" ] && [ "$lista_negra" != "" ]; then
	     b=1
	    condicion_blanca=$(echo $lista_blanca| cut -d "," -f$b)
	    while [ "$condicion_blanca" != "" ]; do
		blanca[$b]=$condicion_blanca
		((b++))
		condicion_blanca=$(echo $lista_blanca| cut -d "," -f$b)
	    done
	    for i in "${blanca[@]}"; do
		echo $i
	    done
       elif [ "$lista_blanca" != "" ] && ["$lista_negra" = "" ]; then
	     lista_def=$lista_blanca
       elif [ "$lista_negra" != "" ] && [ $lista_blanca = "" ]; then
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
	echo ${#blanca[*]}
	update_branchs pullall ${blanca[@]}
   else
      echo "fwefew"
   fi


