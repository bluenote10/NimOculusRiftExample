
import utils
import glm
from strutils import `%`, join
import os

import window
import shader
import ../bindings/ovr as ovr
import opengl

echo "\n *** ----------------- running -----------------"

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

#opengl.loadExtensions()



var shaderProg = shader.shaderProgramCreate("", "")
echo "returned from shaderProgramCreate"
os.sleep(1000)


echo "done"    
    



