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
import opengl
import wrapgl
import glfw/glfw
import glfw/wrapper
import framebuffer
import ovrwrapper as ovrwrappermodule



#{.emit: """ printf("Size of: %d", sizeof(int)); """}

{.emit: """
#include <stdio.h>
#include <stdlib.h>

void c_call()
{
  printf("Size of ptrdiff_t: %d\n", sizeof(ptrdiff_t));
}
"""}

proc c_call() {.importc, nodecl.}
c_call()

when defined(testing):
  quit 0

echo "\n *** ----------------- running -----------------"


#type SafeSeq = seq[int] not nil
#let x = SafeSeq(@[1,2,3])

var running = true

proc keyHandler(win: Win, key: Key, scanCode: int, action: KeyAction, modKeys: ModifierKeySet) =
  echo key
  if key == keyEscape:
    running = false


let hmd = initHmdInstance()

var win = createWindow(20, 20, 1920, 1080)

let ovrWrapper = initOvrWrapper(hmd)

var shader = initDefaultLightingShader("shader/GaussianLighting")
let vd = VertexDataGen.randomMess
#let vd = VertexDataGen.cube(-0.1, 0.1, -0.1, 0.1, -1.1, -0.9, nColor(1,0,0))
#let vd = VertexDataGen.cube(-0.1, 0.1, -0.1, 0.1, -0.1, 0.1, nColor(1,0,0))
#let vd = VertexDataGen.cube(-100.1, 100.1, -100.1, 100.1, -100.1, 100.1, nColor(1,0,0,1))
#var shader = DefaultLightingShader() # how can I avoid such a bug?

let vbo = initStaticVbo(vd, shader)

#quit 0

proc render(mset: MatrixSet) =
  #GlWrapper.ClearColor.set(nColor(1, 1, 1))
  #glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  #glClear(GL_DEPTH_BUFFER_BIT)
  shader.use()
  shader.setProjection(mset.projection)
  shader.setModelview(mset.modelview)

  vbo.render()  


  discard """
  GlWrapper.Program.set(0)
  
  var buf: array[0..15, float32]
  var width, height: cint
  getFramebufferSize(win.getHandle, width.addr, height.addr);
  let ratio = width / (float) height;
  glViewport(0, 0, width, height);
  glClear(GL_COLOR_BUFFER_BIT);
  
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  #glOrtho(-ratio, ratio, -1.0, 1.0, 1.0, -1.0);
  buf = mset.projection.getData
  glLoadMatrixf(cast[ptr GLfloat](buf.addr))
  let ptrV = cast[ptr GLfloat](buf[0].addr)
  debug mset.projection.getData.repr
  debug ptrV[]
  debug cast[ptr array[0..15, GLfloat]](ptrV).repr
  debug ptrV.repr
  
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  #glRotatef((float) getTime() * 50.0, 0.0, 0.0, 1.0);
  buf = mset.modelview.getData
  glLoadMatrixf(cast[ptr GLfloat](buf.addr))
  let ptrM = cast[ptr GLfloat](buf[0].addr)
  debug ptrM[]
  debug cast[ptr array[0..15, GLfloat]](ptrM).repr
  
  glBegin(GL_TRIANGLES);
  glColor3f(  1.0,  0.0,  0.0);
  glVertex3f(-0.6, -0.4, -1.0);
  glColor3f(  0.0,  1.0,  0.0);
  glVertex3f( 0.6, -0.4, -1.0);
  glColor3f(  0.0,  0.0,  1.0);
  glVertex3f( 0.0,  0.6, -1.0);
  glEnd();
  glBegin(GL_TRIANGLES);
  glColor3f(  1.0,  0.0,  0.0);
  glVertex3f(-0.6, -0.4, +1.0);
  glColor3f(  0.0,  1.0,  0.0);
  glVertex3f( 0.6, -0.4, +1.0);
  glColor3f(  0.0,  0.0,  1.0);
  glVertex3f( 0.0,  0.6, +1.0);
  glEnd();
  """

  discard """
  var width, height: cint
  getFramebufferSize(win.getHandle, width.addr, height.addr);
  let ratio = width / (float) height;
  glViewport(0, 0, width, height);
  glClear(GL_COLOR_BUFFER_BIT);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(-ratio, ratio, -1.0, 1.0, 1.0, -1.0);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glRotatef((float) getTime() * 50.0, 0.0, 0.0, 1.0);
  glBegin(GL_TRIANGLES);
  glColor3f(1.0, 0.0, 0.0);
  glVertex3f(-0.6, -0.4, 0.0);
  glColor3f(0.0, 1.0, 0.0);
  glVertex3f(0.6, -0.4, 0.0);
  glColor3f(0.0, 0.0, 1.0);
  glVertex3f(0.0, 0.6, 0.0);
  glEnd();
  """
  
var numFrames = 0

runTimed(time):
  while not win.shouldClose:
    ovrWrapper.render(render)
    win.handleInput()
    numFrames += 1


    discard """
    var width, height: cint
    getFramebufferSize(win.getHandle, width.addr, height.addr);
    let ratio = width / (float) height;
    glViewport(0, 0, width, height);
    glClear(GL_COLOR_BUFFER_BIT);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(-ratio, ratio, -1.0, 1.0, 1.0, -1.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glRotatef((float) getTime() * 50.0, 0.0, 0.0, 1.0);
    glBegin(GL_TRIANGLES);
    glColor3f(1.0, 0.0, 0.0);
    glVertex3f(-0.6, -0.4, 0.0);
    glColor3f(0.0, 1.0, 0.0);
    glVertex3f(0.6, -0.4, 0.0);
    glColor3f(0.0, 0.0, 1.0);
    glVertex3f(0.0, 0.6, 0.0);
    glEnd();
    """
    
    discard """
    glViewport(0, 0, 1920, 1080)
    glClearColor(1.0, 1.0, 1.0, 1.0)
    glClear(GL_COLOR_BUFFER_BIT);
    glLoadIdentity();
    glTranslatef(-1.5,0.0,-6.0);
    glBegin(GL_TRIANGLES);      
    glColor3f(1,0,0)
    glVertex3f( 0.0, 100.0, 0.0);
    glVertex3f(-100.0,-100.0, 0.0);
    glVertex3f( 100.0,-100.0, 0.0);
    glEnd();
    glCheckError(true)
    glFlush();
    """
    
    #win.swapBufs
    #if numFrames == 10: break

echo "Total number of frames: ", numFrames
echo "Runtime: ", time
echo "FPS: ", numFrames.float / time
#os.sleep(1000)


#var shaderProg = shaderProgramCreate("shader/GaussianLighting.vs", "shader/GaussianLighting.fs")
#echo "returned from shaderProgramCreate"


echo "done"
    



