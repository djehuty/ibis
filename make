#!/bin/sh

for item in `find . -name \*.rs`;
do
  echo "--> ${item:2:-3}"
  ./buildlib ${item:2:-3}
done
