
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

iterator items*[T](s: Slice[T]): T =
  for i in s.a .. s.b:
    yield i

when false:    
  iterator `..`*[S, T](a: S, b: T): tuple[key: int, val: T] {.inline.} =
    ## An alias for `countup`.
    var i = 0
    var x = a
    while x <= int(b):
      yield (i, x)
      inc i
      inc x
    
iterator pairs*[T](s: Slice[T]): tuple[key: int, val: T] {.inline.} =
  var i = 0
  for x in s.a .. s.b:
    yield (i, x)
    inc i
    
    
template toArray[T](slice: Slice[T]): expr =
  var result: array[slice.b-slice.a+1, slice.T]
  for i, x in pairs(slice):
    result[i] = x
  result

var arr = (1..10).toArray
echo repr(arr)

  
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
