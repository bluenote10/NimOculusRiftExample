#!/bin/bash

export LD_LIBRARY_PATH=/usr/local/lib

#nim c -r --define:release src/main.nim
#nim c -r --define:testing --passL:"-lOVRRT64_0.so.5" src/main.nim

#nim c -r --define:testing --clibdir:"/usr/local/lib" --threads:on src/main.nim

nim c --define:testing -d:useGlew --clibdir:"/usr/local/lib" --parallelBuild:1 -o:../bin/main src/main.nim


#nim c -r --threads:on threadtestmain.nim

#nim c -r -o=../bin/example src/sandbox.nim
#nim c -r src/sandbox.nim

#nim c -r --define:testing --clibdir:"/usr/local/lib" --threads:on src/backgroundjob.nim


compiler_exit=$?
echo "Compiler Exit: $compiler_exit"

if [ "$compiler_exit" -eq 0 ] ; then  # compile success
  bin/main
fi
