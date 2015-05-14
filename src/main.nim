{.hint[Path]: off.}
{.hint[Processing]: off.}
{.hint[XDeclaredButNotUsed]: off.}
#{.hint[Linking]: off.}


type
  Test = object

proc chain(a, b: Test): Test = b

let a = Test()
let b = Test()
let c = a.chain(b)



import utils
import glm
from strutils import `%`, join
import os

import window
import shaders
import vbos
import vertexdata
import opengl
import wrapgl
import glfw/glfw
import framebuffer
import ovrwrapper as ovrwrappermodule

when defined(testing):
  quit 0

echo "\n *** ----------------- running -----------------"


var running = true

proc keyHandler(win: Win, key: Key, scanCode: int, action: KeyAction, modKeys: ModifierKeySet) =
  echo key
  if key == keyEscape:
    running = false


let hmd = initHmdInstance()

var win = createWindow(20, 20, 1920, 1080)

let ovrWrapper = initOvrWrapper(hmd)

var shader = initDefaultLightingShader("shader/GaussianLighting")
#let vd = VertexDataGen.cube(-0.1, 0.1, -0.1, 0.1, -0.1, 0.1, nColor(1,0,0))
let vd = VertexDataGen.cube(-10.1, 10.1, -10.1, 10.1, -10.1, 10.1, nColor(1,0,0,1))
#var shader = DefaultLightingShader() # how can I avoid such a bug?

let vbo = initStaticVbo(vd, shader)

#quit 0

proc render(mset: MatrixSet) =
  GlWrapper.ClearColor.set(nColor(1, 1, 1))
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  #glClear(GL_DEPTH_BUFFER_BIT)
  shader.use()
  shader.setProjection(mset.projection)
  shader.setModelview(mset.modelview)

  vbo.render()  

var numFrames = 0

runTimed(time):
  while not win.shouldClose:
    ovrWrapper.render(render)
    win.handleInput()
    numFrames += 1

    #if numFrames == 10: break

echo "Total number of frames: ", numFrames
echo "Runtime: ", time
echo "FPS: ", numFrames.float / time
#os.sleep(1000)


#var shaderProg = shaderProgramCreate("shader/GaussianLighting.vs", "shader/GaussianLighting.fs")
#echo "returned from shaderProgramCreate"


echo "done"
    



