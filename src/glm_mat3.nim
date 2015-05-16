

type
  Mat3Index = range[0..2]
  Mat3* = object
    data*: array[9, ftype]

proc `[]`*(m: Mat3, i, j: Mat3Index): ftype =
  m.data[j*3 + i]

proc `[]=`*(m: var Mat3, i, j: Mat3Index, x: ftype) =
  m.data[j*3 + i] = x
  
proc `*`*(this: Mat3, that: Mat3): Mat3 =
  for i in 0 .. <3:
    for j in 0 .. <3:
      for k in 0 .. <3:
        result[i,j] = result[i,j] + this[i,k] * that[k,j]
        #result[i,j] += this[i,k] * that[k,j]
  
proc `$`*(m: Mat3): string =
  "Mat3($#)" % m.data.map(proc (x: ftype): string = $x).join(", ")

proc getData*(m: Mat3): array[9, ftype] = m.data

proc transpose*(m: Mat3): Mat3 =
  for i in 0 .. <3:
    for j in 0 .. <3:
      result[i,j] = m[j,i]


# Constructors
proc nMat3(m00, m01, m02,
           m10, m11, m12,
           m20, m21, m22: ftype): Mat3 =
  ## arguments are row-major to simplify construction
  ## convert to a column-major format for internal storage.
  Mat3(data: [
    m00, m10, m20,
    m01, m11, m21,
    m02, m12, m22
  ])
  
proc identity*(T: typedesc[Mat3]): Mat3 =
  nMat3(
    1, 0, 0,
    0, 1, 0,
    0, 0, 1
  )

proc zero*(T: typedesc[Mat3]): Mat3 =
  nMat3(
    0, 0, 0,
    0, 0, 0,
    0, 0, 0
  )

# Additional operations
proc inverse*(m: Mat3): Mat3 =
  let a = m[0,0]
  let b = m[1,0]
  let c = m[2,0]
  let d = m[0,1]
  let e = m[1,1]
  let f = m[2,1]
  let g = m[0,2]
  let h = m[1,2]
  let i = m[2,2]
  let det = 1.0 / (a*(e*i-f*h) - b*(d*i-f*g) + c*(d*h-e*g))
  result = nMat3(
    det*(e*i-f*h), det*(c*h-b*i), det*(b*f-c*e),
    det*(f*g-d*i), det*(a*i-c*g), det*(c*d-a*f),
    det*(d*h-e*g), det*(b*g-a*h), det*(a*e-b*d)
  )

