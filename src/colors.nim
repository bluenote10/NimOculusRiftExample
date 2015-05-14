type
  Color* = object
    r*, g*, b*, a*: float32

proc nColor*(r, g, b, a: float32): Color =
  Color(r: r, g: g, b: b, a: a)

proc nColor*(r, g, b: float32): Color =
  Color(r: r, g: g, b: b, a: 1)
  
