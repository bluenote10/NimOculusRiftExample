
import opengl
export opengl.GLuint

#import future
import utils


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

var depthTestVar = defineStateWrapper[bool,Switchable](depthTestChanger)

proc DepthTest*(T: typedesc[GlWrapper]): var StateWrapper[bool,Switchable] = depthTestVar


# shader program
proc shaderChanger(id: GLuint) =
  glUseProgram(id)

var vertexShaderProgVar = defineStateWrapper[GLuint,Default](shaderChanger)

proc Program*(T: typedesc[GlWrapper]): var StateWrapper[GLuint,Default] = vertexShaderProgVar


# vertex array object
proc vaoChanger(vao: GLuint) =
  glBindVertexArray(vao)

var vertexArrayObjectVar = defineStateWrapper[GLuint,Default](vaoChanger)

proc VertexArrayObject*(T: typedesc[GlWrapper]): var StateWrapper[GLuint,Default] = vertexArrayObjectVar


