
type
  Vec3* = object
    x*, y*, z*: ftype

proc nVec3*(x, y, z: ftype): Vec3 = Vec3(x: x, y: y, z: z)

# scalar operators
proc `*`*(v: Vec3, a: ftype): Vec3 = nVec3(v.x*a, v.y*a, v.z*a)
proc `/`*(v: Vec3, a: ftype): Vec3 = nVec3(v.x/a, v.y/a, v.z/a)

# vector-vector operators
proc `+`*(v1: Vec3, v2: Vec3): Vec3 = nVec3(v1.x+v2.x, v1.y+v2.y, v1.z+v2.z)
proc `-`*(v1: Vec3, v2: Vec3): Vec3 = nVec3(v1.x-v2.x, v1.y-v2.y, v1.z-v2.z)

proc `*`*(v1: Vec3, v2: Vec3): ftype = v1.x*v2.x + v1.y*v2.y + v1.z*v2.z

proc negate*(v: Vec3): Vec3 = nVec3(-v.x, -v.y, -v.z)

proc length*(v: Vec3): ftype = math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z)

proc setLengthTo*(v: Vec3, a: ftype): Vec3 = v * (a / v.length)

proc normalize*(v: Vec3): Vec3 = v / v.length

proc mid*(v1: Vec3, v2: Vec3): Vec3 =
  ## returns the mid point of v1 and v2
  nVec3(
    0.5*(v1.x+v2.x),
    0.5*(v1.y+v2.y),
    0.5*(v1.z+v2.z)
  )

proc `><`*(v1: Vec3, v2: Vec3): Vec3 =
  ## cross product operator (for lack of better symbols?)
  nVec3(
    v1.y*v2.z - v1.z*v2.y,
    v1.z*v2.x - v1.x*v2.z,
    v1.x*v2.y - v1.y*v2.x
  )
  


    
