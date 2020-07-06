#!/bin/bash

declare -a gbulid=("node-pm2-alpine")
whatuse="node-pm2-alpine"

echo "Let's build :)"
gonline="no"

bulid()
{
  echo "Start build..."
  for i in "${gbulid[@]}";
  do 
    if [[ $whatuse == *"$i"* ]]; then

     echo "$i...."
     docker build -t "repo.volcanoyt.com/base:$i" -f "$i"/Dockerfile .
    
     if [[ $gonline == *"yes"* ]]; then
      echo "Start push to our server"
      docker push repo.volcanoyt.com/module/base:"$i"
     fi

    else
     echo "Skip $i"
    fi
  done
}

push()
{
  echo "Start push..."
  for i in "${gbulid[@]}";
  do 
    if [[ $whatuse == *"$i"* ]]; then

     echo "$i...."
     docker push repo.volcanoyt.com/module/base:"$i"

    else
     echo "Skip $i"
    fi
  done
}

if [ $# -eq 0 ]; then
  echo "Type build like bash run.sh bulid etc,etc,etc"
else

  tmpuse="$2"
  if [ -n "$tmpuse" ]
  then
      whatuse="$tmpuse"
  fi
  
  gonline="$3"   
  case $1 in bulid|push)
    $1
    ;;
  esac
fi