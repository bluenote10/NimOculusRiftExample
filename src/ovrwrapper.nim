
import ../bindings/ovr as ovr
import opengl
import glm
import utils

type
  HmdInstance = object
    hmd: Hmd

proc callback(level: cint; message: cstring) {.cdecl.} =
  echo "Log: " & $level & $message
  
proc initHmdInstance*(): HmdInstance =

  var initParams: ovr.InitParams
  initParams.Flags = Init_Debug
  initParams.LogCallback = callback
  echo repr(initParams)

  var success = ovr.initialize(initParams.addr).toBool
  if not success:
    quit "Error: could not initialize OVR library"

  var numberOfHmds = ovr.hmdDetect()
  if numberOfHmds <= 0:
    quit "Error: OVR library does not see any HMD"

  # simply create the first hmd
  var hmd = ovr.hmdCreate(0)
  echo "HMD detected: ", hmd.repr

  HmdInstance(hmd: hmd)
  

proc getPerspectiveProjection(hmd: Hmd, eye: int, znear = 0.001, zfar = 10000.0): Mat4 =
  let fovPort = hmd.DefaultEyeFov[eye]
  let ovrMat = Matrix4f_Projection(fovPort, znear, zfar, Projection_RightHanded)
  for i in 0 .. 3:
    for j in 0 .. 3:
      result[i,j] = ovrMat.M[j][i]

type 
  TextureGL*  = object 
    Header* : TextureHeader
    TexId: GLuint

  
type
  OvrWrapper = object
    hmd: Hmd

proc initOvrWrapper*(hmdInst: HmdInstance): OvrWrapper =
  let hmd = hmdInst.hmd
  
  let fovPorts = [hmd.DefaultEyeFov[0], hmd.DefaultEyeFov[1]]
  let projections = [hmd.getPerspectiveProjection(0), hmd.getPerspectiveProjection(1)]
  #echo fovPorts
  #echo projections[0]
  #echo projections[1]

  let oversampling = 1.0
  var eyeTextures = [TextureGL(), TextureGL()]
  for eye in 0 .. 1:
    eyeTextures[eye].Header.API = RenderAPI_OpenGL
    #eyeTextures[eye].Header.TextureSize.w =
  debug repr(eyeTextures)
  
  OvrWrapper(hmd: hmdInst.hmd)
