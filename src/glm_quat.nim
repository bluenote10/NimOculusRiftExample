
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

