
import tables
import opengl
import wrapgl
import hashes
import glm
import macros

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
    let p1 = nVec3(min(x1, x2), min(y1, y2), max(z1, z2))
    let p2 = nVec3(max(x1, x2), min(y1, y2), max(z1, z2))
    let p3 = nVec3(min(x1, x2), max(y1, y2), max(z1, z2))
    let p4 = nVec3(max(x1, x2), max(y1, y2), max(z1, z2))
    let p5 = nVec3(min(x1, x2), min(y1, y2), min(z1, z2))
    let p6 = nVec3(max(x1, x2), min(y1, y2), min(z1, z2))
    let p7 = nVec3(min(x1, x2), max(y1, y2), min(z1, z2))
    let p8 = nVec3(max(x1, x2), max(y1, y2), min(z1, z2))

    var vd = initVertexData(10, {vkPos3D: 0, vkNormal: 12, vkColor: 24}.toTable)

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
    
    result = vd
    
