
import wrapgl
import opengl
import vertexdata
import utils

type
  StaticVbo*[Shader] = object
    vd: VertexData
    shader: Shader
    vaoId: GLuint
    vbId: GLuint


proc initStaticVbo*[Shader](vd: VertexData, shader: Shader): StaticVbo[Shader] =

  # initialize a VAO and bind it
  let vaoId = glGenVertexArrays()
  GlWrapper.VertexArrayObject.set(vaoId)

  # initialize the VBO and bind it
  let vbId = glGenBuffers()
  glBindBuffer(GL_ARRAY_BUFFER, vbId)
  debug(vbId)

  # make the attribute bindings
  # that is where the association between the VAO and the current GL_ARRAY_BUFFER is evaluated and stored
  echo "\n *** Calling setVertexAttribArrayAndPointer"
  shader.setVertexAttribArrayAndPointer(vd)

  # buffer the static vertex data
  #var buffer: seq[float32]
  #shallowCopy buffer, vd.data
  var buffer = vd.data
  glBufferData(GL_ARRAY_BUFFER, GLsizeiptr(vd.sizeInBytes), buffer.addr, GL_STATIC_DRAW) # TODO: GLsizeiptr?
  #glBufferData(GL_ARRAY_BUFFER, (vd.sizeInBytes).GLsizeiptr, buffer.addr, GL_STATIC_DRAW) # TODO: GLsizeiptr?
  glCheckError()
  debug buffer

  # unbind everything
  glBindBuffer(GL_ARRAY_BUFFER, 0)
  GlWrapper.VertexArrayObject.set(0)
  glCheckError()
  
  StaticVbo[Shader](vd: vd, shader: shader, vaoId: vaoId, vbId: vbId)


proc render*[Shader](vbo: StaticVbo[Shader]) =
  # bind
  GlWrapper.VertexArrayObject.set(vbo.vaoId)

  # activate shader
  vbo.shader.use()

  # draw
  glDrawArrays(GLenum(vbo.vd.primitiveType), 0, GLsizei(vbo.vd.numVertices))


proc delete*[Shader](vd: VertexData) =
  glDeleteBuffers(vd.vbId)
  glDeleteVertexArrays(vd.vaoId)



