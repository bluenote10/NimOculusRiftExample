
from strutils import `%`, join

import typetraits

proc takesTuple(t: tuple) =
  echo t
  echo t.type.name # crashes
  echo t.type.arity # crashes
  echo repr(t.type) # crashes as well, but with: Error: internal error: GetUniqueType, No stack traceback available

var
  t = (1, "Test", (1,2,3), 3.14)

takesTuple(t)

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


template toArray[T](slice: Slice[T]): stmt =
  #var result = array[]
  echo slice.a
  echo slice.b
  var result: array[slice.b-slice.a, slice.T]
  #for i in slice:
  #  echo i

#toArray(1..10)
(1..10).toArray


for i in 5..15:
  echo i

import typetraits
  
when true:
  const slice = 5..15
  #echo slice.type.name
  for i in slice:
    echo i

  
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
