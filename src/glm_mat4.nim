

type
  Mat4Index = range[0..3]
  Mat4* {.bycopy.} = object
    data*: array[16, float]

proc `[]`*(m: Mat4, i, j: Mat4Index): float =
  m.data[j*4 + i]

proc `[]=`*(m: var Mat4, i, j: Mat4Index, x: float) =
  m.data[j*4 + i] = x
  
proc `*`(this: Mat4, that: Mat4): Mat4 =
  #var data = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
  #result = Mat4(data: data)
  for i in 0 .. <4:
    for j in 0 .. <4:
      for k in 0 .. <4:
        result[i,j] = result[i,j] + this[i,k] * that[k,j]
        #result[i,j] += this[i,k] * that[k,j]
  

proc `$` *(m: Mat4): string =
  "Mat4($#)" % m.data.map(proc (x: float): string = $x).join(", ")

proc mat4CreateIdentity*(): Mat4 =
  result = Mat4(data: [1.0,0.0,0.0,0.0, 0.0,1.0,0.0,0.0, 0.0,0.0,1.0,0.0, 0.0,0.0,0.0,1.0])

proc getData*(m: Mat4): array[16, float] = m.data
  

runUnitTests:
  var
    m = mat4CreateIdentity()
    o = mat4CreateIdentity()

  echo m, m[0,0], m*o

