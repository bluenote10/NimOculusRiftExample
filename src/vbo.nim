
import wrapgl
import opengl

type
  StaticVbo*[VertexData, Shader] = object
    vd: VertexData
    shader: Shader
    vao: GLuint


proc initStaticVbo[VertexData, Shader](vd: VertexData, shader: Shader): StaticVbo[VertexData, Shader] =

  # initialize a VAO and bind it
  let vao = glGenVertexArrays()
  GlWrapper.VertexArrayObject.set(vao)

  # initialize the VBO and bind it
  let vbId = glGenBuffers()
  glBindBuffer(GL_ARRAY_BUFFER, vbId)

  # make the attribute bindings
  # that is where the association between the VAO and the current GL_ARRAY_BUFFER is evaluated and stored
  #shader.setVertexAttribArrayAndPointer(vd)

  # buffer the static vertex data
  echo vd.addr
  #glBufferData(GL_ARRAY_BUFFER, vd.addr, GL_STATIC_DRAW)

  StaticVbo[VertexData, Shader](vd: vd, shader: shader, vao: vao)



type
  VertexData = ref VertexDataObj

  VertexDataObj = object
    data: seq[float]


type
  DefaultLightingShader = object

proc setVertexAttribArrayAndPointer(s: DefaultLightingShader, vd: VertexData) =
  echo "Test"

var vd = VertexData.new
vd.data = @[0.0]
var shader = DefaultLightingShader()

let x = initStaticVbo(vd, DefaultLightingShader)
