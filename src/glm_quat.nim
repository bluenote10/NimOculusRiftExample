
type
  Quaternion* = object
    x*, y*, z*, w*: float

proc nQuaternion*(x, y, z, w: float): Quaternion = Quaternion(x: x, y: y, z: z, w: w)

proc `*`*(q1: Quaternion, q2: Quaternion): Quaternion = nQuaternion(
    q1.w*q2.x + q1.x*q2.w + q1.y*q2.z - q1.z*q2.y,
    q1.w*q2.y + q1.y*q2.w + q1.z*q2.x - q1.x*q2.z,
    q1.w*q2.z + q1.z*q2.w + q1.x*q2.y - q1.y*q2.x,
    q1.w*q2.w - q1.x*q2.x - q1.y*q2.y - q1.z*q2.z
  )

proc normalize*(v: Quaternion): Quaternion =
  let sum = math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z + v.w*v.w)
  nQuaternion(v.x/sum, v.y/sum, v.z/sum, v.w/sum)

proc normalizeMut*(v: var Quaternion) =
  let sum = math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z + v.w*v.w)
  v.x /= sum
  v.y /= sum
  v.z /= sum
  v.w /= sum

proc inverse*(v: Quaternion): Quaternion =
  nQuaternion(-v.x, -v.y, -v.z, +v.w)

proc inverseMut*(v: var Quaternion) =
  v.x = -v.x
  v.y = -v.y
  v.z = -v.z
  # v.w remains the same


proc castToOrientationMatrix*(v: Quaternion): Mat4 =
  let (x, y, z, w) = (v.x, v.y, v.z, v.w)
  nMat4(
    1-2*y*y-2*z*z,   2*x*y-2*w*z,   2*x*z+2*w*y,   0,
      2*x*y+2*w*z, 1-2*x*x-2*z*z,   2*y*z-2*w*x,   0, 
      2*x*z-2*w*y,   2*y*z+2*w*x, 1-2*x*x-2*y*y,   0,
                0,             0,             0,   1       
  )
