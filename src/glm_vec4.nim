
type
  Vec4* = object
    x*, y*, z*, w*: float

proc nVec4*(x, y, z, w: float): Vec4 = Vec4(x: x, y: y, z: z, w: w)   

## scalar operators
proc `*`*(v: Vec4, a: float): Vec4 = nVec4(v.x*a, v.y*a, v.z*a, v.w*a)
proc `/`*(v: Vec4, a: float): Vec4 = nVec4(v.x/a, v.y/a, v.z/a, v.w/a)

## vector-vector operators
proc `+`*(v1: Vec4, v2: Vec4): Vec4 = nVec4(v1.x+v2.x, v1.y+v2.y, v1.z+v2.z, v1.w+v2.w)
proc `-`*(v1: Vec4, v2: Vec4): Vec4 = nVec4(v1.x-v2.x, v1.y-v2.y, v1.z-v2.z, v1.w-v2.w)

proc `*`*(v1: Vec4, v2: Vec4): float = v1.x*v2.x + v1.y*v2.y + v1.z*v2.z + v1.w*v2.w

proc negate*(v: Vec4): Vec4 = nVec4(-v.x, -v.y, -v.z, -v.w)

proc length*(v: Vec4): float = math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z + v.z*v.z)

proc setLengthTo*(v: Vec4, a: float): Vec4 = v * (a / v.length)

proc normalize*(v: Vec4): Vec4 = v / v.length

proc mid*(v1: Vec4, v2: Vec4): Vec4 =
  ## returns the mid point of v1 and v2
  nVec4(
    0.5*(v1.x+v2.x),
    0.5*(v1.y+v2.y),
    0.5*(v1.z+v2.z),
    0.5*(v1.w+v2.w)
  )

  
