
import opengl
import os
import option

type
  ShaderType = enum
    FragmentShader = GL_FRAGMENT_SHADER,
    VertexShader   = GL_VERTEX_SHADER,

  ShaderId = GLuint # we operate on the native IDs, just give it a nicer name.
  ProgramId = GLuint

proc isOkay(id: GLuint): bool =
  id.int != 0
  
proc compileShader(source: string, typ: ShaderType): Option[ShaderId] =

  let shaderId = glCreateShader(typ.Glenum)
  echo "Shader ID ", shaderId
  #assert(shaderId.isOkay)

  # convert source string to arrays of strings + lengths
  var sourceArr = allocCStringArray([source])
  var sourceLen: array[1, GLint] = [source.len.GLint]
  
  glShaderSource(shaderId, 1, sourceArr, sourceLen[0].addr)
  glCompileShader(shaderId)

  var status: GLint
  glGetShaderiv(shaderId, GL_COMPILE_STATUS, status.addr)

  if status == 0:
    var logLen: GLint
    glGetShaderiv(shaderId, GL_INFO_LOG_LENGTH, logLen.addr)

    var retInfoLog = newStringOfCap(logLen)
    var retLength: GLsizei
    glGetShaderInfoLog(shaderId, logLen.GLsizei, retLength.addr, retInfoLog)

    echo "Error compiling shader: ", retInfoLog

    result = none[ShaderId]()
  else:
    result = some(shaderId)
    
  
proc linkProgram(vsId, fsId: ShaderId): Option[ProgramId] =

  if not (vsId.isOkay and fsId.isOkay):
    return none[ProgramId]()

  let progId = glCreateProgram()
  assert progId.isOkay
  
  glAttachShader(progId, vsId)
  glAttachShader(progId, fsId)

  proc getProgramStatus(statusFlag: GLenum): int =
    var status: GLint
    glGetProgramiv(progId, statusFlag, status.addr)
    return status.int
  
  proc getProgramInfoLog(): string = 
    var logLen: GLint
    glGetProgramiv(progId, GL_INFO_LOG_LENGTH, logLen.addr)

    var retInfoLog = newStringOfCap(logLen)
    var retLength: GLsizei
    glGetProgramInfoLog(progId, logLen.GLsizei, retLength.addr, retInfoLog)
    return retInfoLog
    
  # link
  glLinkProgram(progId)
  if getProgramStatus(GL_LINK_STATUS) == 0:
    let errorMsg = getProgramInfoLog()
    echo "Error linking program: ", errorMsg
    return none[ProgramId]()

  # validate
  glValidateProgram(progId)
  if getProgramStatus(GL_VALIDATE_STATUS) == 0:
    let errorMsg = getProgramInfoLog()
    echo "Error validating program: ", errorMsg
    return none[ProgramId]()

  return some(progId)





type
  ShaderProg = object
    id: ProgramId
    
proc shaderProgramCreate*(vsFile, fsFile: string): ShaderProg =

  let vsId = compileShader(vsFile, ShaderType.VertexShader)
  let fsId = compileShader(fsFile, ShaderType.FragmentShader)

  vsId.use:
    echo "TEST"
  
  discard """
  let id = linkProgram(vsFile, fsFile)

  if id.isEmpty:
    raise newException("Could not generate shader program")
  else:
    #let id = id.get
    discard
  """
  

  
