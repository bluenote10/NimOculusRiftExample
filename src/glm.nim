
import utils
import math
from strutils import `%`, join

type
  ftype* = float32

include glm_vec3
include glm_vec4

include glm_mat3
include glm_mat4

include glm_quat

# Some cross conversions
# Placed here to avoid order dependence / forward declarations.

proc toMat3*(m: Mat4): Mat3 =
  nMat3(
    m[0,0], m[0,1], m[0,2],
    m[1,0], m[1,1], m[1,2],
    m[2,0], m[2,1], m[2,2],
  )






