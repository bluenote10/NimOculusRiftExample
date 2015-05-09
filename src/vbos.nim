
import wrapgl
import opengl
import vertexdata

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

  # make the attribute bindings
  # that is where the association between the VAO and the current GL_ARRAY_BUFFER is evaluated and stored
  shader.setVertexAttribArrayAndPointer(vd)

  # buffer the static vertex data
  var buffer: seq[float32]
  shallowCopy buffer, vd.data
  glBufferData(GL_ARRAY_BUFFER, GLsizeiptr(vd.sizeInBytes), buffer.addr, GL_STATIC_DRAW) # TODO: GLsizeiptr?
  #glBufferData(GL_ARRAY_BUFFER, (vd.sizeInBytes).GLsizeiptr, buffer.addr, GL_STATIC_DRAW) # TODO: GLsizeiptr?

  # unbind everything
  glBindBuffer(GL_ARRAY_BUFFER, 0)
  GlWrapper.VertexArrayObject.set(0)
  
  StaticVbo[Shader](vd: vd, shader: shader, vaoId: vaoId, vbId: vbId)


proc render*[Shader](vd: VertexData) =
  # bind
  GlWrapper.VertexArrayObject.set(vd.vao)

  # activate shader
  vd.shader.use()

  # draw
  glDrawArrays(vd.primitiveType, 0, vertexData.numVertices)


proc delete*[Shader](vd: VertexData) =
  glDeleteBuffers(vd.vbId)
  glDeleteVertexArrays(vd.vaoId)


