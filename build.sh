#!/bin/bash

export LD_LIBRARY_PATH=/usr/local/lib

#nim c -r --define:release src/main.nim
#nim c -r --define:testing --passL:"-lOVRRT64_0.so.5" src/main.nim
#nim c -r --define:testing --clibdir:"/usr/local/lib" --threads:on src/main.nim



nim c -r --threads:on threadtestmain.nim

