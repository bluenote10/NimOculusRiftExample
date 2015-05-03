
# the older nimrod-glfw binding
#import src/glfw3 as glfw

# the newer nim-glfw binding:
import glfw/glfw
import opengl

# using liblwjgl3-deb from:
# https://launchpad.net/~keithw/+archive/ubuntu/glfw3

proc createWindow*(posX, posY, w, h: int): Win =

  glfw.init()
  
  var win = newGlWin(
    title = "Minimal example",
    dim = (w, h),
    decorated = false,
    version = glv33,
    forwardCompat = true,
    )
  win.pos = (posX, posY)
  result = win

  win.makeContextCurrent

  opengl.loadExtensions()


proc closeWindow(win: Win) =

  win.destroy()
  glfw.terminate()



