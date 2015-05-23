
import math
import tables
import hashes
import macros
import utils
import opengl
import wrapgl
import glm

proc hash*[T: Ordinal](x: T): THash {.inline.} = 
  ## efficient hashing of any ordinal type (e.g. enums)
  result = x.ord

type
  f32 = float32
  VertexDataGen* = object
  

type

  VertexData* = object
    data*: seq[float32]
    primitiveType*: int
    floatsPerVertex*: int
    vaOffsets*: VertexOffsets

  VertexOffsets* = Table[VertexKind,int]

  VertexKind* = enum
    vkPos3D,
    vkNormal,
    vkColor,
    vkTexCrd,



proc numVertices*(vd: VertexData): int =
  vd.data.len div vd.floatsPerVertex

proc strideInBytes*(vd: VertexData): int =
  vd.floatsPerVertex * 4

proc sizeInBytes*(vd: VertexData): int =
  vd.data.len * 4

proc `+=`*(vd: var VertexData, v: Vec3) =
  vd.data.add(v.x)
  vd.data.add(v.y)
  vd.data.add(v.z)

proc `+=`*(vd: var VertexData, c: Color) =
  vd.data.add(c.r)
  vd.data.add(c.g)
  vd.data.add(c.b)
  vd.data.add(c.a)

macro addAll*(vd: var VertexData, args: varargs[expr]): stmt =
  result = newNimNode(nnkStmtList, args)
  for i in 0 ..< args.len:
    let node = infix(vd, "+=", args[i])
    result.add(node)
  #echo result.treerepr
  

  
proc initVertexData*(floatsPerVertex: int, vaOffsets: VertexOffsets, primitiveType = GL_TRIANGLES): VertexData =
  VertexData(
    data: @[],
    primitiveType: primitiveType,
    floatsPerVertex: floatsPerVertex,
    vaOffsets: vaOffsets
  )
  
proc vdGenEmpty*(): VertexData =
  VertexData(
    data: @[],
    primitiveType: GL_TRIANGLES,
    floatsPerVertex: 10,
    vaOffsets: {vkPos3d: 0}.toTable
  )


proc cube*(T: typedesc[VertexDataGen],
          x1: f32, x2: f32, y1: f32, y2: f32, z1: f32, z2: f32,
          color: Color): VertexData =
  var vd = initVertexData(10, {vkPos3D: 0, vkNormal: 12, vkColor: 24}.toTable)
  vd.addCube(x1, x2, y1, y2, z1, z2, color)
  result = vd

proc addCube*(vd: var VertexData,
          x1: f32, x2: f32, y1: f32, y2: f32, z1: f32, z2: f32,
          color: Color) =
  assert vd.primitiveType == GL_TRIANGLES
  assert vd.floatsPerVertex == 10
  assert vd.vaOffsets.get(vkPos3D)  == some(0)
  assert vd.vaOffsets.get(vkNormal) == some(12)
  assert vd.vaOffsets.get(vkColor)  == some(24)
  let p1 = nVec3(min(x1, x2), min(y1, y2), max(z1, z2))
  let p2 = nVec3(max(x1, x2), min(y1, y2), max(z1, z2))
  let p3 = nVec3(min(x1, x2), max(y1, y2), max(z1, z2))
  let p4 = nVec3(max(x1, x2), max(y1, y2), max(z1, z2))
  let p5 = nVec3(min(x1, x2), min(y1, y2), min(z1, z2))
  let p6 = nVec3(max(x1, x2), min(y1, y2), min(z1, z2))
  let p7 = nVec3(min(x1, x2), max(y1, y2), min(z1, z2))
  let p8 = nVec3(max(x1, x2), max(y1, y2), min(z1, z2))
  # front face
  vd.addAll(p1, nVec3(0,0,+1), color,    p2, nVec3(0,0,+1), color,    p4, nVec3(0,0,+1), color)
  vd.addAll(p4, nVec3(0,0,+1), color,    p3, nVec3(0,0,+1), color,    p1, nVec3(0,0,+1), color)
  # back face
  vd.addAll(p5, nVec3(0,0,-1), color,    p7, nVec3(0,0,-1), color,    p8, nVec3(0,0,-1), color)
  vd.addAll(p8, nVec3(0,0,-1), color,    p6, nVec3(0,0,-1), color,    p5, nVec3(0,0,-1), color)
  # right face
  vd.addAll(p2, nVec3(+1,0,0), color,    p6, nVec3(+1,0,0), color,    p8, nVec3(+1,0,0), color)
  vd.addAll(p8, nVec3(+1,0,0), color,    p4, nVec3(+1,0,0), color,    p2, nVec3(+1,0,0), color)
  # left face
  vd.addAll(p1, nVec3(-1,0,0), color,    p3, nVec3(-1,0,0), color,    p7, nVec3(-1,0,0), color)
  vd.addAll(p7, nVec3(-1,0,0), color,    p5, nVec3(-1,0,0), color,    p1, nVec3(-1,0,0), color)
  # top face
  vd.addAll(p3, nVec3(0,+1,0), color,    p4, nVec3(0,+1,0), color,    p8, nVec3(0,+1,0), color)
  vd.addAll(p8, nVec3(0,+1,0), color,    p7, nVec3(0,+1,0), color,    p3, nVec3(0,+1,0), color)
  # bottom face
  vd.addAll(p1, nVec3(0,-1,0), color,    p5, nVec3(0,-1,0), color,    p6, nVec3(0,-1,0), color)
  vd.addAll(p6, nVec3(0,-1,0), color,    p2, nVec3(0,-1,0), color,    p1, nVec3(0,-1,0), color)
 

proc randomMess*(T: typedesc[VertexDataGen]): VertexData =
  var vd = initVertexData(10, {vkPos3D: 0, vkNormal: 12, vkColor: 24}.toTable)

  let color = nColor(1,0,0)
  proc r(): float32 = random(100.0) - 50

  for i in 1..1000:
    let p1 = nVec3(r(), r(), r())
    let p2 = nVec3(r(), r(), r())
    let p3 = nVec3(r(), r(), r())
    let p4 = nVec3(r(), r(), r())

    vd.addAll(p1, nVec3(r(),r(),r()), color,    p2, nVec3(r(),r(),r()), color,    p4, nVec3(r(),r(),r()), color)
    vd.addAll(p4, nVec3(r(),r(),r()), color,    p3, nVec3(r(),r(),r()), color,    p1, nVec3(r(),r(),r()), color)

  result = vd

