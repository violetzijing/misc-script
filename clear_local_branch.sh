#!/bin/bash
cd /home/violet/code/qa-test-metadata/tmp/repositories/qa-testsuites

array=(`git branch -a | grep metadata`)

for i in "${array[@]}"
do
  git branch -D $i
done
