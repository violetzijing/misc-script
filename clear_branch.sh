#!/bin/bash
cd /home/violet/code/qa-testsuites

array=(`git branch -a | grep metadata`)

for i in "${array[@]}"
do
  a=`basename "$i"`
  echo $a
  git push origin :$a
done
