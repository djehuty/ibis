#!/bin/sh

for item in `find . -name \*.rs`;
do
  echo "--> ${item:2:-3}"
  ./build ${item:2:-3}
done
