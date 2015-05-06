
import wrapgl
#import opengl

type
  StaticVbo*[VertexData, Shader] = object
    vd: VertexData
    shader: Shader
    vao: GLuint


proc initStaticVbo[VertexData, Shader](vd: VertexData, shader: Shader): StaticVbo[VertexData, Shader] =

  let vao = glGenVertexArrays()
  VertexArrayObject.set(vao)
  
  StaticVbo[VertexData, Shader](vd: vd, shader: shader, vao: vao)


let x = initStaticVbo(1,1)
