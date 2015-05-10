
import ../bindings/ovr as ovr
import opengl
import framebuffer
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

proc `xor`[T: enum](x: T, y: T): cuint = (x.int xor y.int).cuint
proc `xor`[T: enum](x: T, y: int): cuint = (x.int xor y).cuint
proc `xor`[T: enum](x: int, y: T): cuint = (x xor y.int).cuint

proc `xor`(x: int, y: cuint): cuint = (x xor y.int).cuint
proc `xor`(x: cuint, y: int): cuint = (x.int xor y).cuint


      
type 
  TextureGL*  = object 
    Header*: TextureHeader
    TexId*: GLuint



type
  OvrWrapper = object
    hmd: Hmd

    
proc initOvrWrapper*(hmdInst: HmdInstance, uncapped = false): OvrWrapper =
  let hmd = hmdInst.hmd
  
  let fovPorts = [hmd.DefaultEyeFov[0], hmd.DefaultEyeFov[1]]
  let projections = [hmd.getPerspectiveProjection(0), hmd.getPerspectiveProjection(1)]
  #echo fovPorts
  #echo projections[0]
  #echo projections[1]

  let oversampling = 1.0
  var eyeTextures = [TextureGL(), TextureGL()]
  var eyeFramebuffers: array[0..1, FramebufferTexture]
  
  for eye in 0 .. 1:
    let recommendedSize = hmd.getFovTextureSize(eye.EyeType, fovPorts[eye], oversampling)

    eyeFramebuffers[eye] = initFramebufferTexture(recommendedSize.w, recommendedSize.h)

    eyeTextures[eye].Header.API = RenderAPI_OpenGL
    eyeTextures[eye].Header.TextureSize = recommendedSize
    eyeTextures[eye].Header.RenderViewport.Size = recommendedSize
    eyeTextures[eye].Header.RenderViewport.Pos = Vector2i(x: 0, y: 0)
    eyeTextures[eye].TexId = eyeFramebuffers[eye].id

  when false:
    echo eyeTextures[0].Header.API
    echo eyeTextures[0].TexId
    echo eyeTextures[1].Header.API
    echo eyeTextures[1].TexId
    debug repr(eyeTextures)

  # generate render API config
  var rc = RenderAPIConfig()
  rc.Header.API = RenderAPI_OpenGL
  rc.Header.BackBufferSize = hmd.Resolution
  rc.Header.Multisample = 0 # does not seem to have any effect?

  # set hmd caps
  let hmdCaps = HmdCap_LowPersistence xor
                HmdCap_DynamicPrediction xor
                #ovrHmdCap_ExtendDesktop xor
                (if uncapped: HmdCap_NoVSync else: 0) xor
                0
  echo hmdCaps
  #hmd.setEnabledCaps(hmdCaps)
  
  OvrWrapper(hmd: hmdInst.hmd)

