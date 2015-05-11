
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

proc `or`(x: int, y: cuint): cuint = (x or y.int).cuint
proc `or`(x: cuint, y: int): cuint = (x.int or y).cuint

proc `or`[T: enum](x: T, y: T): cuint = (x.int or y.int).cuint
proc `or`[T: enum](x: T, y: cuint): cuint = (x.int or y).cuint
proc `or`[T: enum](x: cuint, y: T): cuint = (x or y.int).cuint



      
type 
  TextureGL*  = object 
    Header*: TextureHeader
    TexId*: GLuint



type
  EyeArray[T] = array[0..1, T]

  OvrWrapper = object
    hmd: Hmd
    projections: EyeArray[Mat4]
    eyeTextures: EyeArray[Texture]
    hmdToEyeViewOffsets: EyeArray[Vector3f]
    framebuffers: EyeArray[FramebufferTexture]

  MatrixSet* = object
    projection*: Mat4
    modelview*: Mat4
    

proc initOvrWrapper*(hmdInst: HmdInstance, uncapped = false): OvrWrapper =
  let hmd = hmdInst.hmd

  # set hmd caps
  let hmdCaps = HmdCap_LowPersistence or
                HmdCap_DynamicPrediction or
                #ovrHmdCap_ExtendDesktop or
                (if uncapped: HmdCap_NoVSync.int else: 0)

  hmd.setEnabledCaps(hmdCaps)

  # initialize fov ports and projections
  var fovPorts = [hmd.DefaultEyeFov[0], hmd.DefaultEyeFov[1]]
  let projections = [hmd.getPerspectiveProjection(0), hmd.getPerspectiveProjection(1)]
  #echo fovPorts
  #echo projections[0]
  #echo projections[1]

  # initialize textures
  let oversampling = 1.0
  var eyeTexturesGL = [TextureGL(), TextureGL()]
  var eyeFramebuffers: EyeArray[FramebufferTexture]
  
  for eye in 0 .. 1:
    let recommendedSize = hmd.getFovTextureSize(eye.EyeType, fovPorts[eye], oversampling)

    eyeFramebuffers[eye] = initFramebufferTexture(recommendedSize.w, recommendedSize.h)

    eyeTexturesGL[eye].Header.API = RenderAPI_OpenGL
    eyeTexturesGL[eye].Header.TextureSize = recommendedSize
    eyeTexturesGL[eye].Header.RenderViewport.Size = recommendedSize
    eyeTexturesGL[eye].Header.RenderViewport.Pos = Vector2i(x: 0, y: 0)
    eyeTexturesGL[eye].TexId = eyeFramebuffers[eye].id


  var eyeTextures = [Texture(), Texture()]
  eyeTextures[0] = cast[Texture](eyeTexturesGL[0])
  eyeTextures[1] = cast[Texture](eyeTexturesGL[1])
    
  when false:
    echo eyeTexturesGL[0].Header.API
    echo eyeTexturesGL[0].TexId
    echo eyeTexturesGL[1].Header.API
    echo eyeTexturesGL[1].TexId
    debug repr(eyeTexturesGL)
    debug repr(eyeTextures)

  # preparations for "configureRendering"
  var rc = RenderAPIConfig()
  rc.Header.API = RenderAPI_OpenGL
  rc.Header.BackBufferSize = hmd.Resolution
  rc.Header.Multisample = 0 # does not seem to have any effect?

  let distortionCaps = 
    DistortionCap_Vignette or
    #DistortionCap_NoRestore or
    DistortionCap_Overdrive or
    DistortionCap_ProfileNoSpinWaits or
    (if uncapped: 0 else: DistortionCap_TimeWarp.int)
    
  var eyeRenderDescs: array[0..1, EyeRenderDesc]
  #let success = hmd.configureRendering(rc.addr, distortionCaps, fovPorts[0].addr, eyeRenderDescs[0].addr).toBool
  let renderingOk = hmd.configureRendering(rc.addr, distortionCaps, fovPorts, eyeRenderDescs).toBool
  debug renderingOk
  debug repr(eyeRenderDescs)

  # start tracking
  let trackingCaps =
    TrackingCap_Orientation or
    TrackingCap_Position or
    TrackingCap_MagYawCorrection
  let trackingOk = hmd.configureTracking(trackingCaps, 0).toBool
  debug trackingOk

  # prepare hmdToEyeViewOffsets
  let hmdToEyeViewOffsets = [
    Vector3f(
      x: eyeRenderDescs[0].HmdToEyeViewOffset.x,
      y: eyeRenderDescs[0].HmdToEyeViewOffset.y,
      z: eyeRenderDescs[0].HmdToEyeViewOffset.z,
    ),
    Vector3f(
      x: eyeRenderDescs[1].HmdToEyeViewOffset.x,
      y: eyeRenderDescs[1].HmdToEyeViewOffset.y,
      z: eyeRenderDescs[1].HmdToEyeViewOffset.z,
    )
  ]
  
  OvrWrapper(
    hmd: hmdInst.hmd,
    projections: projections,
    eyeTextures: eyeTextures,
    hmdToEyeViewOffsets: hmdToEyeViewOffsets,
    framebuffers: eyeFramebuffers
  )



proc render*(ovr: OvrWrapper, renderProc: proc (mset: MatrixSet)) =
  let hmd = ovr.hmd
  let numFrames = 0
  
  let frameTiming = hmd.beginFrame(0)

  var eyePoses: array[0..1, Posef]
  var trackingState: TrackingState
  hmd.getEyePoses(numFrames.cuint, ovr.hmdToEyeViewOffsets, eyePoses, trackingState.addr)
  debug repr(eyePoses)
  debug repr(trackingState)

  for i in 0 .. 1:
    let eye = hmd.EyeRenderOrder[i].int
    
    let P = ovr.projections[eye]

    let pose = eyePoses[eye]

    let PcurInv = Mat4.translate(-pose.Position.x, -pose.Position.y, -pose.Position.z)
    let QcurInv = nQuaternion(-pose.Orientation.x, -pose.Orientation.y, -pose.Orientation.z, pose.Orientation.w).castToOrientationMatrix
    # let Pref = ctrMatPos
    # let Qref = ctrMatOri

    let V = QcurInv * PcurInv # * Pref * Qref
    
    ovr.framebuffers[eye].activate()
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
    renderProc(MatrixSet(projection: P, modelview: V))
    ovr.framebuffers[eye].deactivate()

    
  hmd.endFrame(eyePoses, ovr.eyeTextures)
  
