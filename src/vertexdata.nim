
import tables
import opengl
import hashes

proc hash*[T: Ordinal](x: T): THash {.inline.} = 
  ## efficient hashing of any ordinal type (e.g. enums)
  result = x.ord


type
  VertexData* = object
    data*: seq[float32]
    primitiveType*: int
    floatsPerVertex*: int
    vaOffsets*: Table[VertexAttribute,int]

  VertexAttribute* = enum
    vaHasPos3D,
    vaHasNormal,
    vaHasColor,
    vaHasTexCrd,



proc numVertices*(vd: VertexData): int =
  vd.data.len div vd.floatsPerVertex

proc strideInBytes*(vd: VertexData): int =
  vd.floatsPerVertex * 4

proc sizeInBytes*(vd: VertexData): int =
  vd.data.len * 4


proc vdGenEmpty*(): VertexData =
  VertexData(
    data: @[],
    primitiveType: GL_TRIANGLES,
    floatsPerVertex: 10,
    vaOffsets: {vaHasPos3d: 0}.toTable
  )


