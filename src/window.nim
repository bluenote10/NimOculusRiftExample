
# Note on lwjgl3:
# Ubuntu 14.04 only comes with version 2 of lwjgl
# liblwjgl3-deb can be obtained from:
# https://launchpad.net/~keithw/+archive/ubuntu/glfw3

# the older nimrod-glfw binding
# import src/glfw3 as glfw

# the newer nim-glfw binding (provides a nicer interface):
import glfw/glfw

import utils
import opengl
import wrapgl

export shouldClose
export swapBufs
export getHandle

import glfw/wrapper
export wrapper.getFramebufferSize
export wrapper.getTime


proc keyHandler(win: Win, key: Key, scanCode: int, action: KeyAction, modKeys: ModifierKeySet) =
  echo key


proc createWindow*(posX, posY, w, h: int): Win =
  
  glfw.init()
  
  var win = newGlWin(
    title = "Oculus Rift Example",
    dim = (w, h),
    decorated = false,
    version = glv33,
    forwardCompat = false, # not recommended for OpenGL 3.2+ https://www.opengl.org/wiki/Core_And_Compatibility_in_Contexts
    profile = glpCompat, # eventually, switch to glpCore
    nMultiSamples = 4,
    )

  # set things which are not exposed by constructor
  win.pos = (posX, posY)
  win.keyCb = keyHandler

  # use context and load extensions
  win.makeContextCurrent
  opengl.loadExtensions()

  # misc OpenGL setup
  glEnable(GL_BLEND)
  glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA)
  glEnable(GL_MULTISAMPLE_ARB)
  glEnable(GL_CULL_FACE)
  GlWrapper.DepthTest.on()

  # using the rift, we are not supposed to vsync on client side.
  # should have no effect, since we do not call swapBuf anyways,
  # but just to make sure
  swapInterval(0)
  
  result = win


proc closeWindow*(win: Win) =
  win.destroy()
  glfw.terminate()


proc handleInput*(win: Win) =
  pollEvents()
  # TODO: return accumulated key events from keyHandler

