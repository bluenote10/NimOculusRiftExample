{.hint[Path]: off.}
{.hint[Processing]: off.}
{.hint[XDeclaredButNotUsed]: off.}
#{.hint[Linking]: off.}

import utils
import glm
from strutils import `%`, join
import os

import window
import shaders
import vbos
import vertexdata
#import opengl
import wrapgl
import framebuffer
import ovrwrapper as ovrwrappermodule

echo "\n *** ----------------- running -----------------"

let hmd = initHmdInstance()

var win = createWindow(100, 100, 800, 600)

let ovrWrapper = initOvrWrapper(hmd)


let vd = VertexDataGen.cube(-0.1, 0.1, -0.1, 0.1, -0.1, 0.1, nColor(1,0,0))
var shader = initDefaultLightingShader("shader/GaussianLighting")
#var shader = DefaultLightingShader() # how can I avoid such a bug?

let vbo = initStaticVbo(vd, shader)


proc render(mset: MatrixSet) =
  shader.use()
  shader.setProjection(mset.projection)
  shader.setModelview(mset.modelview)

  vbo.render()  


for i in 0 .. 100000:
  ovrWrapper.render(render)
  echo 0

#os.sleep(1000)


#var shaderProg = shaderProgramCreate("shader/GaussianLighting.vs", "shader/GaussianLighting.fs")
#echo "returned from shaderProgramCreate"


echo "done"
    



