#!/bin/bash
# -*- ENCODING: UTF-8 -*-

#Stops script if any error
set -e

CURRENT_PATH=`pwd`
#Current branch
BRANCH=`git rev-parse --abbrev-ref HEAD 2> /dev/null`

#Check if a .git folder exits
function check_git_dir(){
	if [ ! -d .git ]; then
            echo "Can't find git in the current path: $CURRENT_PATH"
            exit -1
        fi
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

function load_gitconfig(){
  git config include.path ../.gitconfig
}

function option_default(){
   if [ $(git config  --get $1.default)=="" ];then
       lista_blanca=$(load_white_list)
       brname=git branch -r| grep -v "HEAD"|cut -d "/" -f1
       if [ "$lista_blanca"="" ]; then
	  lista_negra=$(load_black_list)
	  if [ "$lista_negra"="" ]; then
              update_all_branchs
              exit 1
	  else
	      i=1
	      for branch in `git branch -r  | grep -v HEAD|cut -d "/" -f2`; do
		      final=$(echo $lista_negra| cut -d "," -f$i)
		      while [ "$final" != $branch ]; do
		            git checkout $branch
		  	    git $1 $brname $branch
		            ((i++))
		            final=$(echo $lista_negra| cut -d "," -f$i)
		      done
		  git checkout $branch
		  git $1 $brname $branch
	      done
	  fi
       else
	    i=1
            final=$(echo $lista_blanca| cut -d "," -f$i)
            while [ "$final" != "" ]; do
                  git checkout $final
		  git $1 $brname $final
                  ((i++))
                  final=$(echo $lista_blanca| cut -d "," -f$i)
            done
       fi
   else
       $(git config  --get $1.default)
   fi
}

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

includePathGitconfig=$(git config include.path)

if [ "$includePathGitconfig" = "" ]; then
    load_configure_file
fi
