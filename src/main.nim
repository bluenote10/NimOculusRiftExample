
import utils
import glm
import opengl
import src/glfw3
from strutils import `%`, join

import ../bindings/ovr as ovr

echo "Hello World"

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
  
runUnitTests():
  echo "Main"
    
    



