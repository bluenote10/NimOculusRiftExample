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
import ../bindings/ovr as ovr
#import opengl

echo "\n *** ----------------- running -----------------"
var vd = vdGenEmpty()
var shader = DefaultLightingShader()

let x = initStaticVbo(vd, shader)
quit()

proc callback(level: cint; message: cstring) {.cdecl.} =
  echo "Log: " & $level & $message

var initParams: ovr.InitParams
initParams.Flags = Init_Debug
initParams.LogCallback = callback
echo repr(initParams)

block:
  var success = ovr.initialize(initParams.addr).toBool
  echo "result: " & $success

block:
  var index = ovr.hmdDetect()
  echo "index: ", index

  var hmd = ovr.hmdCreate(index-1)
  echo "hmd: ", hmd.repr

var win = createWindow(100, 100, 800, 600)
sleep(1000)



var shaderProg = shaderProgramCreate("shader/GaussianLighting.vs", "shader/GaussianLighting.fs")
echo "returned from shaderProgramCreate"
#os.sleep(1000)


echo "done"
    



