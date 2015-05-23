import vertexdata
import tables
import sequtils
import math
import utils
import strutils
import wrapgl

type
  Brick = object
    wx,wy: int
  Anchor = tuple[x,y: int]

proc nBrick(wx, wy: int): Brick = Brick(wx: wx, wy: wy)

proc rotate(b: Brick): Brick = nBrick(b.wy, b.wx)

const possibleBricks = [
  nBrick(1,1),
  nBrick(2,1),
  nBrick(2,2),
  nBrick(4,1),
  nBrick(4,2),
  #nBrick(8,1),
  #nBrick(8,2),
]

proc randomBrick(): Brick =
  let maxIndex = possibleBricks.len
  let i = random(maxIndex)
  if random(2) == 0:
    result = possibleBricks[i]
  else:
    result = possibleBricks[i].rotate
  
proc randomTrapeziodal(N: int): int =
  (random(N) + random(N)) div 2

proc randomAnchor(b: Brick, gridSize: int): Anchor =
  assert gridSize >= b.wx
  assert gridSize >= b.wy
  let ax = randomTrapeziodal(gridSize-b.wx+1)
  let ay = randomTrapeziodal(gridSize-b.wy+1)
  (ax, ay)

proc randomColor(): Color =
  nColor(random(1.0), random(1.0), random(1.0))

iterator iterateCells(b: Brick, anchor: Anchor): (int,int) =
  for i in 0 ..< b.wx:
    for j in 0 ..< b.wy:
      yield (anchor.x+i, anchor.y+j)


proc indexToCoord(i, gridSize: int): float =
  let half = gridSize / 2
  (i.float-half) * 0.008

proc generateWorld*(): VertexData =
  var vd = initVertexData(10, {vkPos3D: 0, vkNormal: 12, vkColor: 24}.toTable)

  let zDist = -0.5
  let yDist = -0.3
  let numBricks = 5000
  let gridSize = 100
  var height = newSeqWith(gridSize, newSeq[int](gridSize))

  for iter in 1 .. numBricks:
    let b = randomBrick()
    let a = randomAnchor(b, gridSize)
    #debug b
    #debug a

    var maxHeight = 0
    for i, j in iterateCells(b, a):
      maxHeight = max(maxHeight, height[i][j])
    maxHeight += 1

    var c = 0
    for i, j in iterateCells(b, a):
      height[i][j] = maxHeight
      c += 1
    assert c == b.wx * b.wy

    #for i in 0 ..< gridSize:
    #  echo height[i].map((i: int) => $i).join("")

    let x1 = indexToCoord(a.x, gridSize)
    let x2 = indexToCoord(a.x+b.wx, gridSize)
    let z1 = indexToCoord(a.y, gridSize)
    let z2 = indexToCoord(a.y+b.wy, gridSize)
    let y1 = (maxHeight  ).float * 0.0096
    let y2 = (maxHeight+1).float * 0.0096
    debug x1,x2,z1,z2,y1,y2
    vd.addCube(x1, x2, y1+yDist, y2+yDist, z1+zDist, z2+zDist, randomColor())

  result = vd
