{.hint[Path]: off.}
{.hint[Processing]: off.}
{.hint[XDeclaredButNotUsed]: off.}
#{.hint[Linking]: off.}


import utils
from strutils import `%`, join
import os

import opengl
import wrapgl
import window
import shaders
import vertexdata
import vbos
import glm
import ovrwrapper as ovrwrappermodule
import world


let vd = generateWorld()
when defined(testing):
  quit 0

echo "\n *** ----------------- running -----------------"


let hmd = initHmdInstance()

echo "Creating window with resolution ", hmd.winRes, " at position ", hmd.winPos
var win = createWindow(
  hmd.winPos.x,
  hmd.winPos.y,
  hmd.winRes.w,
  hmd.winRes.h)


let ovrWrapper = initOvrWrapper(hmd, uncapped = false)

var shader = initDefaultLightingShader("shader/GaussianLighting")
#let vd = VertexDataGen.cube(-0.1, 0.1, -0.1, 0.1, -1.1, -0.9, nColor(1,0,0))

let vbo = initStaticVbo(vd, shader)


proc render(mset: MatrixSet) =
  ## Rendering callback function
  shader.use()
  shader.setProjection(mset.projection)
  shader.setModelview(mset.modelview)

  vbo.render()  


proc renderDebugWithMatrices(mset: MatrixSet) =
  ## This is just an alternative rendering functions,
  ## useful for debugging. It only renders two simple
  ## triangles in immediate mode, but using the projection
  ## and modelview matrices from ``mset``.
  ## Thus, it can be used to see if there are problems
  ## in the vbo/shader based rendering
  GlWrapper.Program.set(0)
  
  var buf: array[0..15, float32]
  #var width, height: cint
  #getFramebufferSize(win.getHandle, width.addr, height.addr);
  #glViewport(0, 0, width, height);
  #glClear(GL_COLOR_BUFFER_BIT);
  
  glMatrixMode(GL_PROJECTION);
  #glLoadIdentity();
  buf = mset.projection.getData
  glLoadMatrixf(cast[ptr GLfloat](buf.addr))
  
  glMatrixMode(GL_MODELVIEW);
  #glLoadIdentity();
  buf = mset.modelview.getData
  glLoadMatrixf(cast[ptr GLfloat](buf.addr))
  
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

proc renderDebugWithoutMatrices(mset: MatrixSet) =
  ## This is just an alternative rendering functions,
  ## useful for debugging. It only renders a single
  ## triangles in immediate mode. I ignored the projection
  ## and modelview matrices from ``mset``, and uses
  ## a simple orthographic projection.
  ## Thus, it can be used to see if rendering works
  ## at all.
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


# the rendering loop
var numFrames = 0

runTimed(time):
  while not win.shouldClose:

    ovrWrapper.render(render)
    numFrames += 1

    # traditional rendering would require to:    
    # win.swapBufs
    # but this is handled by the OVR library

    # polls for input
    win.handleInput()

echo "Total number of frames: ", numFrames
echo "Runtime: ", time
echo "FPS: ", numFrames.float / time
    



