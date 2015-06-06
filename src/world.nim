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

# source: http://www.peeron.com/cgi-bin/invcgis/colorguide.cgi
const possibleColors = [
  nColorInt(242, 243, 242),
  nColorInt(161, 165, 162),
  nColorInt(196, 40, 27),
  nColorInt(13, 105, 171),
  nColorInt(245, 205, 47),
  nColorInt(27, 42, 52),
  nColorInt(40, 127, 70),
  nColorInt(75, 151, 74),
  nColorInt(226, 155, 63),
  nColorInt(160, 95, 52),
]

# source: http://www.robertcailliau.eu/Lego/Dimensions/zMeasurements-en.xhtml
const
  legoWidth  = 0.008
  legoHeight = 0.0096

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
  #nColor(random(1.0), random(1.0), random(1.0))
  let maxIndex = possibleColors.len
  let i = random(maxIndex)
  result = possibleColors[i]

iterator iterateCells(b: Brick, anchor: Anchor): (int,int) =
  for i in 0 ..< b.wx:
    for j in 0 ..< b.wy:
      yield (anchor.x+i, anchor.y+j)


proc indexToCoord(i, gridSize: int): float =
  let half = gridSize / 2
  (i.float-half) * legoWidth

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
    let y1 = (maxHeight  ).float * legoHeight
    let y2 = (maxHeight+1).float * legoHeight
    #debug x1,x2,z1,z2,y1,y2
    vd.addCube(x1, x2, y1+yDist, y2+yDist, z1+zDist, z2+zDist, randomColor())

  result = vd
