
import opengl
export opengl.GLuint

#import future
import utils

include colors


# Error handling
proc glCheckError*(ignoreError = false) =
  let error = glGetError()
  let msg = case error:
    of 0: none(string)
    of GL_INVALID_ENUM: some("GL_INVALID_ENUM")
    of GL_INVALID_VALUE: some("GL_INVALID_VALUE")
    of GL_INVALID_OPERATION: some("GL_INVALID_OPERATION")
    of GL_STACK_OVERFLOW: some("GL_STACK_OVERFLOW")
    of GL_STACK_UNDERFLOW: some("GL_STACK_UNDERFLOW")
    of GL_OUT_OF_MEMORY: some("GL_OUT_OF_MEMORY")
    else: some("meaning of value " & $error & " unknown")
  #if (m ??= msg):
  for m in msg:
    echo "Error: ", m
    if not ignoreError:
      quit "glCheckError occurred"
  


# Simplified overloads
proc glGenVertexArrays*(): GLuint {.inline.} =
  var vao: GLuint
  glGenVertexArrays(1.GLsizei, vao.addr)
  vao

proc glGenBuffers*(): GLuint {.inline.} =
  var id: GLuint
  glGenBuffers(1.GLsizei, id.addr)
  id

proc glGenFrameBuffers*(): GLuint {.inline.} =
  var id: GLuint
  glGenFrameBuffers(1.GLsizei, id.addr)
  id
  
proc glGenTextures*(): GLuint {.inline.} =
  var id: GLuint
  glGenTextures(1.GLsizei, id.addr)
  id

proc glGenRenderbuffers*(): GLuint {.inline.} =
  var id: GLuint
  glGenRenderbuffers(1.GLsizei, id.addr)
  id

proc glDrawBuffers*(buf: GLenum) {.inline.} =
  var tmp = buf
  glDrawBuffers(1.GLsizei, tmp.addr)
  
proc glVertexAttribPointer*(index: int, size: int, `type`: int, normalized: bool, stride: int, offset: int) {.inline.} =
  var tmpOffset = offset
  glVertexAttribPointer(index.GLuint, size.GLint, `type`.GLenum, normalized.GLboolean, stride.GLsizei, tmpOffset.addr)

proc glTexImage2D*(target: int, level: int, internalformat: int, width: int, height: int, border: int, format: int, `type`: int, pixels: pointer) =
  glTexImage2D(target.GLenum, level.GLint, internalformat.GLint, width.GLsizei, height.GLsizei, border.GLint, format.GLenum, `type`.GLenum, pixels)  



# Other minor convenience functions
proc `==`*(x: GLuint, y: GLuint): bool = x.int == y.int


# State wrapping
type
  StateWrapper[T,X] = object
    lastState: Option[T]
    applyStateChange: proc (x: T)

  Default = object
  Switchable = object

  GlWrapper* = object
  
    
proc get*[T,X](sw: StateWrapper[T,X]): Option[T] =
  sw.lastState

proc set*[T,X](sw: var StateWrapper[T,X], x: T) =
  discard """
  if state ?= (sw.lastState):
    echo state
    #if state != x:
    #  sw.applyStateChange(x)
    #  sw.lastState = some(x)
  else:
    sw.lastState = some(x)
  """
  for state in sw.lastState:
    echo "Current state ", state
    if state != x:
      sw.applyStateChange(x)
      sw.lastState = some(x)

  if sw.lastState.isNone:
    sw.applyStateChange(x)
    sw.lastState = some(x)

  echo "State is ", sw.lastState.get.repr
 
proc defineStateWrapper[T,X](f: proc (x: T)): StateWrapper[T,X] =
  StateWrapper[T,X](lastState: none(T), applyStateChange: f)


# special setters for type "Switchable"
proc on*(sw: var StateWrapper[bool,Switchable]) =
  #sw.set[bool,Switchable](true)
  sw.set(true)

proc off*(sw: var StateWrapper[bool,Switchable]) =
  #sw.set[bool,Switchable](false)
  sw.set(false)


# depth test
proc depthTestChanger(x: bool) =
  echo("Setting depth test to ", x)
  if x: glEnable(GL_DEPTH_TEST)
  else: glDisable(GL_DEPTH_TEST)

var depthTestVar = defineStateWrapper[bool,Switchable](depthTestChanger)

proc DepthTest*(T: typedesc[GlWrapper]): var StateWrapper[bool,Switchable] = depthTestVar


# shader program
proc shaderChanger(id: GLuint) =
  echo "Using program: ", id
  glUseProgram(id)

var vertexShaderProgVar = defineStateWrapper[GLuint,Default](shaderChanger)

proc Program*(T: typedesc[GlWrapper]): var StateWrapper[GLuint,Default] = vertexShaderProgVar


# vertex array object
proc vaoChanger(vao: GLuint) =
  echo "Using Vertex Array Object: ", vao
  glBindVertexArray(vao)

var vertexArrayObjectVar = defineStateWrapper[GLuint,Default](vaoChanger)

proc VertexArrayObject*(T: typedesc[GlWrapper]): var StateWrapper[GLuint,Default] = vertexArrayObjectVar

# clear color
proc clearColorChanger(c: Color) =
  glClearColor(c.r, c.g, c.b, c.a)

var clearColorVar = defineStateWrapper[Color,Default](clearColorChanger)

proc ClearColor*(T: typedesc[GlWrapper]): var StateWrapper[Color,Default] = clearColorVar

