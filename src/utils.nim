
from strutils import `%`, join
import macros
import times
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

template runTimed*(into: expr, code: stmt): expr {.immediate.} =
  let s = cpuTime()
  let s2 = epochTime()
  code
  let e = cpuTime()
  let e2 = epochTime()
  echo "Epoch: ", e2-s2
  echo "CPU: ", e-s
  let into {.inject.} = e2-s2



template newSeqFill*(len: int, init: expr): expr =
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
  
macro debug*(n: varargs[expr]): stmt =
  # `n` is a Nim AST that contains the whole macro invocation
  # this macro returns a list of statements:
  result = newNimNode(nnkStmtList, n)
  # iterate over any argument that is passed to this macro:
  for i in 0..n.len-1:
    # add a call to the statement list that writes the expression;
    # `toStrLit` converts an AST to its string representation:
    add(result, newCall("write", newIdentNode("stdout"), toStrLit(n[i])))
    # add a call to the statement list that writes ": "
    add(result, newCall("write", newIdentNode("stdout"), newStrLitNode(": ")))
    # add a call to the statement list that writes the expressions value:
    #add(result, newCall("writeln", newIdentNode("stdout"), n[i]))
    add(result, newCall("write", newIdentNode("stdout"), n[i]))
    # separate by ", "
    if i != n.len-1:
      add(result, newCall("write", newIdentNode("stdout"), newStrLitNode(", ")))

  # add new line
  add(result, newCall("writeln", newIdentNode("stdout"), newStrLitNode("")))


proc `*`*(x: float, y: int): float = x * y.toFloat
proc `*`*(x: int, y: float): float = x.toFloat * y
proc `/`*(x: float, y: int): float = x / y.toFloat
proc `/`*(x: int, y: float): float = x.toFloat / y


template indices*(expr): expr = low(expr) .. high(expr)  



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

include options


proc readFileOpt*(filename: string): Option[string] =
  try:
    let s = readFile(filename)
    some(s)
  except IOError:
    none(string)
  
  

runUnitTests():
  #var s = sprintf(".2f %3d %-5s", 1, 2, "3")
  #echo s
  #assert s == "1.00 2 3    "
  discard
