

type
  Mat4Index = range[0..3]
  Mat4* {.bycopy.} = object
    data*: array[16, float]

proc `[]`*(m: Mat4, i, j: Mat4Index): float =
  m.data[j*4 + i]

proc `[]=`*(m: var Mat4, i, j: Mat4Index, x: float) =
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
  "Mat4($#)" % m.data.map(proc (x: float): string = $x).join(", ")

proc getData*(m: Mat4): array[16, float] = m.data

# Constructors
proc nMat4(m00, m01, m02, m03,
           m10, m11, m12, m13,
           m20, m21, m22, m23,
           m30, m31, m32, m33: float): Mat4 =
  ## arguments are row-major to simplify construction
  ## convert to a column-major format for internal storage.
  Mat4(data: [
    m00, m10, m20, m30,
    m01, m11, m21, m31,
    m02, m12, m22, m32,
    m03, m13, m23, m33,
  ])
  
proc nMat4Identity*(): Mat4 =
  nMat4(
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
  )

proc nMat4Zero*(): Mat4 =
  nMat4(
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0
  )

proc nMat4Translation*(x: float, y: float, z: float): Mat4 =
  nMat4(
    1, 0, 0, x,
    0, 1, 0, y,
    0, 0, 1, z,
    0, 0, 0, 1
  )
  
proc nMat4Scale*(x: float, y: float, z: float): Mat4 =
  nMat4(
    x, 0, 0, 0,
    0, y, 0, 0,
    0, 0, z, 0,
    0, 0, 0, 1
  )


runUnitTests:
  var
    m = nMat4Identity()
    o = nMat4Identity()

  echo m, m[0,0], m*o

