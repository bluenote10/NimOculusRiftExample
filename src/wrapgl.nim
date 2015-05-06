
import opengl
export opengl.GLuint

#import future
import utils

proc glGenVertexArrays*(): GLuint =
  var vao: GLuint
  glGenVertexArrays(1.GLsizei, vao.addr)
  vao



type
  StateWrapper[T,X] = object
    lastState: Option[T]
    applyStateChange: proc (x: T)

  Default = object
  Switchable = object
  
    
proc get*[T,X](sw: StateWrapper[T,X]): Option[T] =
  sw.lastState

proc set*[T,X](sw: var StateWrapper[T,X], x: T) =
  sw.applyStateChange(x)
  sw.lastState = some(x)

proc defineStateWrapper[T,X](f: proc (x: T)): StateWrapper[T,X] =
  StateWrapper[T,X](lastState: none[T](), applyStateChange: f)


# special setters for type "Switchable"
proc on(sw: var StateWrapper[bool,Switchable]) =
  sw.set(true)

proc off(sw: var StateWrapper[bool,Switchable]) =
  sw.set(false)


# depth test
proc depthTestChanger(x: bool) =
  echo("setting depth test to ", x)
  if x: glEnable(GL_DEPTH_TEST)
  else: glDisable(GL_DEPTH_TEST)

var DepthTest* = defineStateWrapper[bool,Switchable](depthTestChanger)


# vertex array object
proc vaoChanger(vao: GLuint) =
  glBindVertexArray(vao)

var VertexArrayObject* = defineStateWrapper[GLuint,Default](vaoChanger)


