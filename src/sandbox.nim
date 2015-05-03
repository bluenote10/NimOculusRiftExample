

when false:
  import sequtils
  template toSeqWithHint(it: expr, hint: int): expr {.immediate.} =
    var result {.gensym.}: seq[type(it)] = @[]
    result.setlen(hint)
    var i = 0
    for x in it:
      result[i] = x
      inc i
    result

  let arr = [1,2,3,4]
  let s1 = toSeq(arr.items)
  let s2 = toSeqWithHint(arr.items, 4)
  #let s3 = arr.items.toSeqWithHint(4)
  #let s3 = items(arr).toSeqWithHint(4)
  echo s1
  echo s2


when false:
  template toSeqWithHint(it: expr, hint: int): expr {.immediate.} =
    var result {.gensym.}: seq[type(it)] = @[] # how to access the underlying type of it=arr?
    result.setlen(hint)
    var i = 0
    for x in it.items:
      #result[i] = x
      echo repr(result)
      inc i
    result

  let arr = [1,2,3,4]
  let s1 = toSeqWithHint(arr, 4)
  echo repr(s1)



when false:
  template enumerate(it: expr): expr =
    var i = 0
    #for 


when false:

  let s1 = @[1,2,3,4]
  let s2 = s1.map(proc (x: int): int = x+1)
             .map(proc (x: int): int = x+1)
             .filter(proc (x: int): bool = x >= 5)

  echo s2


when true:
  iterator myIter(): string =
    yield "Hello"
    yield "World"

  #for x in iter1():
  #  echo x
    
  var it = myIter   # causes: Error: internal error: proc has no result symbol
  #var it = myIter() # causes: Error: undeclared identifier: 'myIter'
  #var i2 = iter1()
    
  #for x in i1():
  #  echo x



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

when false:    
  iterator `..`*[S, T](a: S, b: T): tuple[key: int, val: T] {.inline.} =
    ## An alias for `countup`.
    var i = 0
    var x = a
    while x <= int(b):
      yield (i, x)
      inc i
      inc x

when false:
  iterator enumerate*[T](iter: T): tuple[key: int, val: T] =
    var i = 0
    for x in iter:
      yield (i, x)
      inc i
  
