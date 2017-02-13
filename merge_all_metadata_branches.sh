#!/bin/bash
cd /home/violet/code/qa-testsuites
git pull origin
echo "checkout to merge branch"
git checkout merge

array=(`git branch -a | grep metadata`)

for i in "${array[@]}"
do
  a=`basename "$i"`
  echo $a
  git pull --rebase origin $a
done
