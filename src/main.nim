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
var vd = vdGenEmpty()
var shader = DefaultLightingShader()

#let x = initStaticVbo(vd, shader)
#quit()

let hmd = initHmdInstance()
let ovrWrapper = initOvrWrapper(hmd)
quit 0

var win = createWindow(100, 100, 800, 600)
sleep(1000)



var shaderProg = shaderProgramCreate("shader/GaussianLighting.vs", "shader/GaussianLighting.fs")
echo "returned from shaderProgramCreate"
#os.sleep(1000)


echo "done"
    



