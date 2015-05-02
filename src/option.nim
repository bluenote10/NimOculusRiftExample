
import utils

type
  OptionKind = enum
    None,
    Some

  Option*[T] = object
    case kind: OptionKind
    of None:
      discard
    of Some:
      value*: T


proc `$`*[T](o: Option[T]): string =
  case o.kind:
  of None: result = "None"
  of Some: result = "Some(" & $o.value & ")"

proc `==`*[T](a: Option[T], b: Option[T]): bool =
  #case (a.kind, b.kind):
  #of (None, None): true
  #of (Some, None): false
  #of (None, Some): false
  #of (Some, Some): a.value == b.value
  if a.isEmpty and b.isEmpty:
    true
  elif a.isDefined and b.isDefined:
    a.value == b.value
  else:
    false
  

proc none*[T](): Option[T] =
  Option[T](kind: None)

proc some*[T](value: T): Option[T] =
  Option[T](kind: Some, value: value)


#proc none*(T: typedesc): Option[T] = none[T]()

  
proc map*[T,S](o: Option[T], f: proc (x: T): S {.closure.}): Option[S] =
  case o.kind:
  of None: result = none[S]()
  of Some: result = some[S](f(o.value))

  
proc isDefined*[T](o: Option[T]): bool =
  #o.kind is Some
  case o.kind:
  of None: false
  of Some: true

proc isEmpty*[T](o: Option[T]): bool =
  #if o.kind is None: true else: false
  case o.kind:
  of None: true
  of Some: false


template use*[T](o: Option[T], b: stmt): stmt =
  if o.isDefined:
    b

runUnitTests:
  block:
    var
      x = Option[int](kind: None)
      y = Option[int](kind: Some, value: 1)
    echo x, " ", y
    assert x.isEmpty
    assert y.isDefined
    assert(x != y)

  block:
    var
      x = none[int]()
      y = some[int](1)
      z = some(1)
    echo x, " ", y, " ", z
    assert x.isEmpty
    assert y.isDefined
    assert z.isDefined
    assert (x != y)
    assert (x != z)
    assert (y == z)

  block:
    let a = some(42)
    let a1 = a.map(proc (x: int): float = (2*x).float)
    let a2 = a.map do (x: int) -> float: (2*x).float
    let b = none[int]()
    let b1 = b.map(proc (x: int): float = (2*x).float)
    let b2 = b.map do (x: int) -> float: (2*x).float 
    echo "Mapped: ", a1
    assert a1.isDefined
    assert a2.isDefined
    assert(not b1.isDefined)
    assert(not b2.isDefined)

  block:
    let x = some("test")
    let y = some("test")
    assert (x == y)
    
  block:
    var uninit: Option[int]
    echo "Unitialized: ", uninit
    assert uninit.isEmpty

