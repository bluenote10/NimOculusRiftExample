import vertexdata
import tables
import sequtils
import math
import utils
import strutils

type
  Brick = object
    wx,wy: int

proc nBrick(wx, wy: int): Brick = Brick(wx: wx, wy: wy)

proc rotate(b: Brick): Brick = nBrick(b.wy, b.wx)

const possibleBricks = [
  nBrick(4,1),
  nBrick(4,2),
  nBrick(8,1),
  nBrick(8,2),
]

proc randomBrick(): Brick =
  let maxIndex = possibleBricks.len
  let i = random(maxIndex)
  if random(2) == 0:
    result = possibleBricks[i]
  else:
    result = possibleBricks[i].rotate
  

proc randomAnchor(b: Brick, gridSize: int): (int,int) =
  assert gridSize >= b.wx
  assert gridSize >= b.wy
  let ax = random(gridSize-b.wx+1)
  let ay = random(gridSize-b.wy+1)
  (ax, ay)

iterator iterateCells(b: Brick, anchor: (int,int)): (int,int) =
  for i in 0 ..< b.wx:
    for j in 0 ..< b.wy:
      yield (anchor[0]+i, anchor[1]+j)


proc generateWorld*(): VertexData =
  var vd = initVertexData(10, {vkPos3D: 0, vkNormal: 12, vkColor: 24}.toTable)

  let zDist = 1.0
  let numBricks = 10
  let gridSize = 8
  var height = newSeqWith(gridSize, newSeq[int](gridSize))

  for iter in 1 .. numBricks:
    let b = randomBrick()
    let a = randomAnchor(b, gridSize)
    debug b
    debug a

    var maxHeight = 0
    for i, j in iterateCells(b, a):
      maxHeight = max(maxHeight, height[i][j])
    maxHeight += 1
    for i, j in iterateCells(b, a):
      height[i][j] = maxHeight

    for i in 0 ..< gridSize:
      echo height[i].map((i: int) => $i).join("")

    let x1 = (gridSize/2)
    #vd.addCube(x1, x2, y1, y2, z1, z2, color)
  result = vd
