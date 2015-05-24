
import opengl
import wrapgl
import os
import utils
import tables
import glm
import vertexdata

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
  assert(shaderId.isOkay)

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

    result = none(ShaderId)
  else:
    result = some(shaderId)
    
  
proc linkProgram(vsId, fsId: ShaderId): Option[ProgramId] =

  if not (vsId.isOkay and fsId.isOkay):
    return none(ProgramId)

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
    return none(ProgramId)

  # validate
  glValidateProgram(progId)
  if getProgramStatus(GL_VALIDATE_STATUS) == 0:
    let errorMsg = getProgramInfoLog()
    echo "Error validating program: ", errorMsg
    return none(ProgramId)

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

  debug vsFile, fsFile
  let contentVSOpt = readFileOpt(vsFile)
  let contentFSOpt = readFileOpt(fsFile)

  #if contentVS ?= contentVSOpt and contentFS ?= contentFSOpt:
  for contentVS in contentVSOpt:
   for contentFS in contentFSOpt:
  
    let vsId = compileShader(contentVS, ShaderType.VertexShader)
    let fsId = compileShader(contentFS, ShaderType.FragmentShader)
    debug vsId
    debug fsId
    
    #if (vsId ?= vsId) and (fsId ?= fsId):
    for vsId in vsId:
     for fsId in fsId:
      let pId = linkProgram(vsId, fsId)
      debug pId

      #if pId ?= pId:
      for pId in pId:

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
        debug unifsMap
        debug attrsMap
        assert unifsMap.len == numUnifs
        assert attrsMap.len == numAttrs
      
        return ShaderProg(
          id: pId,
          numUnifs: numUnifs,
          numAttrs: numAttrs,
          unifsMap: unifsMap,
          attrsMap: attrsMap,
        )

  raise newException(Exception, "Could not generate shader program")
  

proc shaderProgramCreate*(filenameBase: string): ShaderProg =
  ## overloaded version which assumes the vs/fs have the same base name
  shaderProgramCreate(filenameBase & ".vs", filenameBase & ".fs")

proc use(sp: ShaderProg) =
  GlWrapper.Program.set(sp.id)

proc getUniformLocation  (sp: ShaderProg, name: string): int = sp.unifsMap.getThrow(name)
proc getAttributeLocation(sp: ShaderProg, name: string): int = sp.attrsMap.getThrow(name)

proc setUniform(sp: ShaderProg, loc: int, x: float) =
  glUniform1f(loc.GLint, x)
proc setUniform(sp: ShaderProg, loc: int, x, y: float) =
  glUniform2f(loc.GLint, x, y)
proc setUniform(sp: ShaderProg, loc: int, x, y, z: float) =
  glUniform3f(loc.GLint, x, y, z)
proc setUniform(sp: ShaderProg, loc: int, x, y, z, w: float) =
  glUniform4f(loc.GLint, x, y, z, w)


proc setUniform(sp: ShaderProg, loc: int, v: Vec3) =
  glUniform3f(loc.GLint, v.x, v.y, v.z)
proc setUniform(sp: ShaderProg, loc: int, v: Vec4) =
  glUniform4f(loc.GLint, v.x, v.y, v.z, v.w)


const transpose = false

proc setUniform(sp: ShaderProg, loc: int, m: Mat3) =
  var data = m.getData
  #glUniformMatrix3fv(loc.GLint, 1, transpose, cast[ptr GLfloat](data[0].addr))
  glUniformMatrix3fv(loc.GLint, 1, transpose, data[0].addr)

proc setUniform(sp: ShaderProg, loc: int, m: var Mat3) =
  glUniformMatrix3fv(loc.GLint, 1, transpose, cast[ptr GLfloat](m.addr))
  
proc setUniform(sp: ShaderProg, loc: int, m: Mat4) =
  var data = m.getData
  #debug sp, loc, m
  #glUniformMatrix4fv(loc.GLint, 1, transpose, cast[ptr GLfloat](data[0].addr))
  #glUniformMatrix4fv(loc.GLint, 1, transpose, data[0].addr)
  glUniformMatrix4fv(loc.GLint, 1, transpose, cast[ptr GLfloat](data.addr))

proc setUniform(sp: ShaderProg, loc: int, m: var Mat4) =
  glUniformMatrix4fv(loc.GLint, 1, transpose, cast[ptr GLfloat](m.addr))




type
  DefaultLightingShader* = object
    prog: ShaderProg
    attrLocPos3D: int
    attrLocNormal: int
    attrLocColor: int
    unifLocCameraToClipMatrix: int
    unifLocModelToCameraMatrix: int
    unifLocNormalModelToCameraMatrix: int
    unifLocCameraSpaceLightPos1: int
    lightPos: Vec3

proc initDefaultLightingShader*(filenameBase: string): DefaultLightingShader =
  let prog = shaderProgramCreate(filenameBase)

  let attrLocPos3D  = prog.getAttributeLocation("position")
  let attrLocNormal = prog.getAttributeLocation("normal")
  let attrLocColor  = prog.getAttributeLocation("inDiffuseColor")

  let unifLocCameraToClipMatrix        = prog.getUniformLocation("cameraToClipMatrix")
  let unifLocModelToCameraMatrix       = prog.getUniformLocation("modelToCameraMatrix")
  let unifLocNormalModelToCameraMatrix = prog.getUniformLocation("normalModelToCameraMatrix")
  let unifLocCameraSpaceLightPos1      = prog.getUniformLocation("cameraSpaceLightPos")

  DefaultLightingShader(
    prog: prog,
    attrLocPos3D: attrLocPos3D,
    attrLocNormal: attrLocNormal,
    attrLocColor: attrLocColor,
    unifLocCameraToClipMatrix: unifLocCameraToClipMatrix,
    unifLocModelToCameraMatrix: unifLocModelToCameraMatrix,
    unifLocNormalModelToCameraMatrix: unifLocNormalModelToCameraMatrix,
    unifLocCameraSpaceLightPos1: unifLocCameraSpaceLightPos1,
    lightPos: nVec3(0,1,0)
  )

proc setVertexAttribArrayAndPointer*(s: DefaultLightingShader, vd: VertexData) =
  try:
    let vaOffsetPos3D  = vd.vaOffsets[vkPos3D]
    let vaOffsetNormal = vd.vaOffsets[vkNormal]
    let vaOffsetColor  = vd.vaOffsets[vkColor]
    glEnableVertexAttribArray(s.attrLocPos3D.GLuint)
    glEnableVertexAttribArray(s.attrLocNormal.GLuint)
    glEnableVertexAttribArray(s.attrLocColor.GLuint)
    #GlWrapper.checkGlError("after enabling vertex attrib array")
    glVertexAttribPointer(s.attrLocPos3D,  3, cGL_FLOAT, false, vd.strideInBytes, vaOffsetPos3D)
    glVertexAttribPointer(s.attrLocNormal, 3, cGL_FLOAT, false, vd.strideInBytes, vaOffsetNormal)
    glVertexAttribPointer(s.attrLocColor,  4, cGL_FLOAT, false, vd.strideInBytes, vaOffsetColor)
    glCheckError()
    debug s.attrLocPos3D, vaOffsetPos3D
    debug s.attrLocNormal, vaOffsetNormal
    debug s.attrLocColor, vaOffsetColor
    debug vd.strideInBytes
  except KeyError:
    quit "vertex data does not provide necessary vertex information: " & $vd.vaOffsets


proc use*(s: DefaultLightingShader) =
  s.prog.use
    
proc setProjection*(s: DefaultLightingShader, P: Mat4) =
  s.prog.use()
  s.prog.setUniform(s.unifLocCameraToClipMatrix, P)

proc setModelview*(s: DefaultLightingShader, V: Mat4, Vinvopt: Option[Mat4] = none(Mat4)) =
  let Vinv: Mat3 = Vinvopt.map((m: Mat4) => m.toMat3)
                          .getOrElse(V.toMat3.inverse.transpose)
  s.prog.use()
  s.prog.setUniform(s.unifLocModelToCameraMatrix, V)
  s.prog.setUniform(s.unifLocNormalModelToCameraMatrix, Vinv)
  let cameraSpaceLightPos = (V * s.lightPos.toVec4).toVec3
  s.prog.setUniform(s.unifLocCameraSpaceLightPos1, cameraSpaceLightPos)

  
