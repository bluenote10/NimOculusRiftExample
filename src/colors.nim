type
  Color* = object
    r*, g*, b*, a*: float32

proc nColor*(r, g, b, a: float32): Color =
  Color(r: r, g: g, b: b, a: a)

proc nColor*(r, g, b: float32): Color =
  Color(r: r, g: g, b: b, a: 1)
  
proc nColorInt*(r, g, b: int): Color =
  Color(r: r/256, g: g/256, b: b/256, a: 1)
