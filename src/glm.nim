
import utils
from strutils import `%`, join

type
  Mat3Index = range[0..2]
  Mat3* {.bycopy.} = object
    data*: array[9, float]

proc `[]`*(m: Mat3, i, j: Mat3Index): float =
  m.data[j*3 + i]

proc `[]=`*(m: var Mat3, i, j: Mat3Index, x: float) =
  m.data[j*3 + i] = x
  
proc `*`(this: Mat3, that: Mat3): Mat3 =
  #var data = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
  #result = Mat3(data: data)
  for i in 0 .. <3:
    for j in 0 .. <3:
      for k in 0 .. <3:
        result[i,j] = result[i,j] + this[i,k] * that[k,j]
        #result[i,j] += this[i,k] * that[k,j]
  

proc `$` *(m: Mat3): string =
  "Mat3($#)" % m.data.map(proc (x: float): string = $x).join(", ")

proc mat3CreateIdentity*(): Mat3 =
  result = Mat3(data: [1.0,0.0,0.0, 0.0,1.0,0.0, 0.0,0.0,1.0])

#proc floatBuffer*(m: var Mat3): pointer = m.data.addr
  

runUnitTests:
  var
    m = mat3CreateIdentity()
    o = mat3CreateIdentity()

  echo m, m[0,0], m*o



