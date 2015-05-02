

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
