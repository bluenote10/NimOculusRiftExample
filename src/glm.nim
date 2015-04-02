
import utils
from strutils import `%`, join

type
  Mat3* = object
    data*: array[9, float]

proc `[]`*(m: Mat3, i, j: int): float =
  m.data[j*3 + i]

proc `[]=`*(m: var Mat3, i, j: int, x: float) =
  m.data[j*3 + i] = x
  
proc `*`(this: Mat3, that: Mat3): Mat3 =
  var data = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
  result = Mat3(data: data)
  for i in 0 .. <3:
    for j in 0 .. <3:
      for k in 0 .. <3:
        #result[i,j] = result[i,j] + this[i,k] * that[k,j]
        result[i,j] += this[i,k] * that[k,j]
  
  
proc m00(m: Mat3): float = m.data[0]
proc m01(m: Mat3): float = m.data[1]
proc m02(m: Mat3): float = m.data[2]
proc m10(m: Mat3): float = m.data[3]
proc m11(m: Mat3): float = m.data[4]
proc m12(m: Mat3): float = m.data[5]
proc m20(m: Mat3): float = m.data[6]
proc m21(m: Mat3): float = m.data[7]
proc m22(m: Mat3): float = m.data[8]

proc `**`(this: Mat3, that: Mat3): Mat3 =
  var data = [
    this.m00 * that.m00 + this.m10 * that.m01 + this.m20 * that.m02,
    this.m01 * that.m00 + this.m11 * that.m01 + this.m21 * that.m02,
    this.m02 * that.m00 + this.m12 * that.m01 + this.m22 * that.m02,
    this.m00 * that.m10 + this.m10 * that.m11 + this.m20 * that.m12,
    this.m01 * that.m10 + this.m11 * that.m11 + this.m21 * that.m12,
    this.m02 * that.m10 + this.m12 * that.m11 + this.m22 * that.m12,
    this.m00 * that.m20 + this.m10 * that.m21 + this.m20 * that.m22,
    this.m01 * that.m20 + this.m11 * that.m21 + this.m21 * that.m22,
    this.m02 * that.m20 + this.m12 * that.m21 + this.m22 * that.m22,
  ]
  Mat3(data: data)

proc `$` *(m: Mat3): string =
  "Mat3($#)" % m.data.map(proc (x: float): string = $x).join(", ")

proc mat3CreateIdentity(): Mat3 =
  result = Mat3(data: [1.0,0.0,0.0, 0.0,1.0,0.0, 0.0,0.0,1.0])


  

runUnitTests:
  echo "GLM"    
    
  var
    m = mat3CreateIdentity()
    o = mat3CreateIdentity()

  echo($m, m.m00, m[0,0], m*o)



