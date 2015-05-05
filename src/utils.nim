
from strutils import `%`, join
#import option


template filename: string =
  instantiationInfo().filename


template runUnitTest*(name: string, code: stmt): stmt {.immediate.} =
  when defined(testing):
    echo " *** Running unit test: " & name
    block:
      code
  
template runUnitTests*(code: stmt): stmt {.immediate.} =
  when defined(testing):
    echo " *** Running units test in " & instantiationInfo().filename
    block:
      code

    
template newSeqFill(len: int, init: expr): expr =
  var result = newSeq[type(init)](len)
  for i in 0 .. <len:
    result[i] = init
  result

template newSeqTabulate*(len: int, typ, iter: expr): expr =
  var result = newSeq[typ](len)
  for ii in 0 .. <len:
    let i {.inject.} = ii.int
    result[i] = iter
  result
  
  
# ------------------------------------------------
# Slice improvements
# ------------------------------------------------
  
iterator items*[T](s: Slice[T]): T =
  for i in s.a .. s.b:
    yield i
    
iterator pairs*[T](s: Slice[T]): tuple[key: int, val: T] {.inline.} =
  var i = 0
  for x in s.a .. s.b:
    yield (i, x)
    inc i
    
template toArray[T](slice: Slice[T]): expr =
  var result: array[slice.b-slice.a+1, slice.T]
  for i, x in pairs(slice):
  #for i, x in enumerate(slice):
    result[i] = x
  result


# ------------------------------------------------
# IO
# ------------------------------------------------

include option


proc readFileOpt*(filename: string): Option[string] =
  try:
    let s = readFile(filename)
    some(s)
  except IOError:
    none[string]()
  
  

runUnitTests():
  #var s = sprintf(".2f %3d %-5s", 1, 2, "3")
  #echo s
  #assert s == "1.00 2 3    "
  discard
