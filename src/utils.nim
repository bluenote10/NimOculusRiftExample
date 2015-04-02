
from strutils import `%`, join


template filename: string =
  instantiationInfo().filename

template runUnitTests*(code: stmt): stmt =
  when defined(testing):
    echo " *** Running units test in " & instantiationInfo().filename
    code

    
template newSeqFill(len: int, init: expr): expr =
  var result = newSeq[type(init)](len)
  for i in 0 .. <len:
    result[i] = init
  result

#proc printf*(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc printf(formatstr: cstring) {.header: "<stdio.h>", importc: "printf", varargs.}

proc sprintf(buffer: cstring, formatstr: cstring) {.header: "<stdio.h>", varargs.}

proc snprintf(buffer: cstring, size: int, formatstr: cstring) {.header: "<stdio.h>", varargs.}

when true:
  #var x = (0..10).map(proc (i: int): int = i+1)
  var bufferSize = 512
  #var buffer = newSeqFill(bufferSize, " ").join
  var buffer = newStringOfCap(bufferSize)
  snprintf(buffer, bufferSize, "%.2f %3d %-5s\n", 1.0, 2, "3")
  echo buffer

when false:
  #printf("Hello Word %d %d %s\n", 1, 2, "3")
  #printf("%.2f %3d %-5s\n", 1.0, 2, "3")
  var buffer = "                              "
  sprintf(buffer, "%.2f %3d %-5s\n", 1.0, 2, "3")
  echo buffer

import typetraits
echo ( .. <10)


runUnitTests():
  #var s = sprintf(".2f %3d %-5s", 1, 2, "3")
  #echo s
  #assert s == "1.00 2 3    "
  discard
