
# the older nimrod-glfw binding
#import src/glfw3 as glfw

# the newer nim-glfw binding:
import glfw/glfw
import opengl
import wrapgl

export shouldClose

# using liblwjgl3-deb from:
# https://launchpad.net/~keithw/+archive/ubuntu/glfw3

proc createWindow*(posX, posY, w, h: int): Win =

  glfw.init()
  
  var win = newGlWin(
    title = "Minimal example",
    dim = (w, h),
    decorated = false,
    version = glv33,
    forwardCompat = false, # not recommended for OpenGL 3.2+ https://www.opengl.org/wiki/Core_And_Compatibility_in_Contexts
    profile = glpCompat, # eventually, switch to glpCore
    )
  win.pos = (posX, posY)
  result = win

  win.makeContextCurrent

  opengl.loadExtensions()

  #glEnable(GL_BLEND)
  #glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA)
  # BlendFunc.setPremultipliedAlpha()

  # glEnable(GL_MULTISAMPLE_ARB)
  # glHint(GL_MULTISAMPLE_FILTER_HINT_NV, GL_NICEST)

  #glPolygonMode( GL_FRONT_AND_BACK, GL_LINE )
  #glEnable(GL_CULL_FACE)
  glDisable(GL_CULL_FACE)
  #GlWrapper.DepthTest.on()
  GlWrapper.DepthTest.off()
  

proc closeWindow(win: Win) =

  win.destroy()
  glfw.terminate()


proc handleInput*(win: Win) =
  pollEvents()

