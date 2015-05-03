
import opengl
import os
import utils
import tables

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
    retInfoLog.setlen(retLength)

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
    retInfoLog.setlen(retLength)
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
  LocationTable = Table[string, int]

  ShaderProg = object
    id: ProgramId
    numUnifs: int
    numAttrs: int
    unifsMap: LocationTable
    attrsMap: LocationTable


proc shaderProgramCreate*(vsFile, fsFile: string): ShaderProg =

  let contentVS = readFileOpt(vsFile)
  let contentFS = readFileOpt(fsFile)

  if (contentVS ?= contentVS) and (contentFS ?= contentFS):
  
    let vsId = compileShader(contentVS, ShaderType.VertexShader)
    let fsId = compileShader(contentFS, ShaderType.FragmentShader)

    if (vsId ?= vsId) and (fsId ?= fsId):
      let pId = linkProgram(vsId, fsId)

      if pId ?= pId:

        var numUnifsRaw: GLint
        glGetProgramiv(pId, GL_ACTIVE_UNIFORMS, numUnifsRaw.addr)
        var numAttrsRaw: GLint
        glGetProgramiv(pId, GL_ACTIVE_ATTRIBUTES, numAttrsRaw.addr)
        let numUnifs = numUnifsRaw.int
        let numAttrs = numAttrsRaw.int
        
        proc extractUnif(i: int): (string,int) =
          var name = newStringOfCap(1024)
          var retLength: GLsizei
          var retSizeOfUnif: GLint
          var retTypeOfUnif: GLenum
          glGetActiveUniform(pId, i.GLuint, 1024.GLsizei, retLength.addr, retSizeOfUnif.addr, retTypeOfUnif.addr, name)
          name.setlen(retLength)
          let loca = glGetUniformLocation(pId, name)
          (name, loca.int)
        
        proc extractAttr(i: int): (string,int) =
          var name = newStringOfCap(1024)
          var retLength: GLsizei
          var retSizeOfAttr: GLint
          var retTypeOfAttr: GLenum
          glGetActiveAttrib(pId, i.GLuint, 1024.GLsizei, retLength.addr, retSizeOfAttr.addr, retTypeOfAttr.addr, name)
          name.setlen(retLength)
          let loca = glGetAttribLocation(pId, name)
          (name, loca.int)

        let unifsMap = newSeqTabulate(numUnifs, (string,int), extractUnif(i)).toTable
        let attrsMap = newSeqTabulate(numAttrs, (string,int), extractAttr(i)).toTable
      
        return ShaderProg(
          id: pId,
          numUnifs: numUnifs,
          numAttrs: numAttrs,
          unifsMap: unifsMap,
          attrsMap: attrsMap,
        )

  raise newException(Exception, "Could not generate shader program")
  
  
#proc 
  
