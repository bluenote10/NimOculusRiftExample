

type
  Mat3Index = range[0..2]
  Mat3* {.bycopy.} = object
    data*: array[9, float]

proc `[]`*(m: Mat3, i, j: Mat3Index): float =
  m.data[j*3 + i]

proc `[]=`*(m: var Mat3, i, j: Mat3Index, x: float) =
  m.data[j*3 + i] = x
  
proc `*`*(this: Mat3, that: Mat3): Mat3 =
  #var data = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
  #result = Mat3(data: data)
  for i in 0 .. <3:
    for j in 0 .. <3:
      for k in 0 .. <3:
        result[i,j] = result[i,j] + this[i,k] * that[k,j]
        #result[i,j] += this[i,k] * that[k,j]
  

proc `$`*(m: Mat3): string =
  "Mat3($#)" % m.data.map(proc (x: float): string = $x).join(", ")

proc getData*(m: Mat3): array[9, float] = m.data

# Constructors
proc nMat3(m00, m01, m02,
           m10, m11, m12,
           m20, m21, m22: float): Mat3 =
  ## arguments are row-major to simplify construction
  ## convert to a column-major format for internal storage.
  Mat3(data: [
    m00, m10, m20,
    m01, m11, m21,
    m02, m12, m22
  ])
  
proc nMat3Identity*(): Mat3 =
  nMat3(
    1, 0, 0,
    0, 1, 0,
    0, 0, 1
  )

proc nMat3Zero*(): Mat3 =
  nMat3(
    0, 0, 0,
    0, 0, 0,
    0, 0, 0
  )


runUnitTests:
  var
    m = nMat3Identity()
    o = nMat3Identity()

  echo m, m[0,0], m*o


