

type
  Mat4Index = range[0..3]
  Mat4* {.bycopy.} = object
    data*: array[16, ftype]

proc `[]`*(m: Mat4, i, j: Mat4Index): ftype =
  m.data[j*4 + i]

proc `[]=`*(m: var Mat4, i, j: Mat4Index, x: ftype) =
  m.data[j*4 + i] = x
  
proc `*`*(this: Mat4, that: Mat4): Mat4 =
  #var data = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
  #result = Mat4(data: data)
  for i in 0 .. <4:
    for j in 0 .. <4:
      for k in 0 .. <4:
        result[i,j] = result[i,j] + this[i,k] * that[k,j]
        #result[i,j] += this[i,k] * that[k,j]
  

proc `$`*(m: Mat4): string =
  "Mat4($#)" % m.data.map(proc (x: ftype): string = $x).join(", ")

proc getData*(m: Mat4): array[16, ftype] = m.data

# Constructors
proc nMat4(m00, m01, m02, m03,
           m10, m11, m12, m13,
           m20, m21, m22, m23,
           m30, m31, m32, m33: ftype): Mat4 =
  ## arguments are row-major to simplify construction
  ## convert to a column-major format for internal storage.
  Mat4(data: [
    m00, m10, m20, m30,
    m01, m11, m21, m31,
    m02, m12, m22, m32,
    m03, m13, m23, m33,
  ])
  
proc identity*(T: typedesc[Mat4]): Mat4 =
  nMat4(
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
  )

proc zero*(T: typedesc[Mat4]): Mat4 =
  nMat4(
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0
  )

proc translate*(T: typedesc[Mat4], x: ftype, y: ftype, z: ftype): Mat4 =
  nMat4(
    1, 0, 0, x,
    0, 1, 0, y,
    0, 0, 1, z,
    0, 0, 0, 1
  )
  
proc scale*(T: typedesc[Mat4], x: ftype, y: ftype, z: ftype): Mat4 =
  nMat4(
    x, 0, 0, 0,
    0, y, 0, 0,
    0, 0, z, 0,
    0, 0, 0, 1
  )


runUnitTests:
  let mustBe: array[0..15, ftype] = [1.0.ftype,5.0,9.0,13.0, 2.0,6.0,10.0,14.0, 3.0,7.0,11.0,15.0, 4.0,8.0,12.0,16.0]

  block:
    var m = Mat4.identity()

    m[0,0] = 1
    m[0,1] = 2
    m[0,2] = 3
    m[0,3] = 4
    m[1,0] = 5
    m[1,1] = 6
    m[1,2] = 7
    m[1,3] = 8
    m[2,0] = 9
    m[2,1] = 10
    m[2,2] = 11
    m[2,3] = 12
    m[3,0] = 13
    m[3,1] = 14
    m[3,2] = 15
    m[3,3] = 16
    assert (m.getData == mustBe)

  block:
    let m = nMat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
    assert (m.getData == mustBe)

  block:
    let m = nMat4(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
    let prod = m * m
    assert prod[0,0] == 90
    assert prod[1,3] == 280
    
