#!/bin/bash

mkdir -p bin

export LD_LIBRARY_PATH=/usr/local/lib

#nim c -r --define:testing --passL:"-lOVRRT64_0.so.5" src/main.nim
nim c --verbosity:0 --define:testing --clibdir:"/usr/local/lib" --parallelBuild:1 -o:../bin/main src/main.nim

compiler_exit=$?
echo "Compiler Exit: $compiler_exit"

if [ "$compiler_exit" -eq 0 ] ; then  # compile success
  echo -e "\n *** Running executable:"
  bin/main
fi
