#***********************************************************************************
#
#Filename    :   OVR_CAPI_0_5_0.h
#Content     :   C Interface to Oculus tracking and rendering.
#Copyright   :   Copyright 2014 Oculus VR, LLC All Rights reserved.
#
#Licensed under the Oculus VR Rift SDK License Version 3.2 (the "License");
#you may not use the Oculus VR Rift SDK except in compliance with the License,
#which is provided at the time of installation or download, or which
#otherwise accompanies this software in either electronic or hard copy form.
#
#You may obtain a copy of the License at
#
#http://www.oculusvr.com/licenses/LICENSE-3.2
#
#Unless required by applicable law or agreed to in writing, the Oculus VR SDK
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
#
#**********************************************************************************
#/ @file OVR_CAPI_0_5_0.h
#/ Exposes all general Rift functionality.

 {.deadCodeElim: on.}
when defined(windows): 
  const 
    libname* = "libOVRRT64_0.dll"
elif defined(macosx): 
  const 
    libname* = "libOVRRT64_0.dylib"
else: 
  const 
    libname* = "libOVRRT64_0.so.5"
##ifndef C2NIM

when not defined(OVR_CAPI_h): # We don't use version numbers within this, as all versioned variations of
  const 
    OVR_CAPI_h* = true        # this file are currently mutually exclusive.
                              ##endif
  #-----------------------------------------------------------------------------------
  # ***** OVR_OS
  #
  #-----------------------------------------------------------------------------------
  # ***** OVR_CPP
  #
  #-----------------------------------------------------------------------------------
  # ***** OVR_CDECL
  #
  # LibOVR calling convention for 32-bit Windows builds.
  #
  #-----------------------------------------------------------------------------------
  # ***** OVR_EXTERN_C
  #
  # Defined as extern "C" when built from C++ code.
  #
  #-----------------------------------------------------------------------------------
  # ***** OVR_PUBLIC_FUNCTION / OVR_PRIVATE_FUNCTION
  #
  # OVR_PUBLIC_FUNCTION  - Functions that externally visible from a shared library. Corresponds to Microsoft __dllexport.
  # OVR_PUBLIC_CLASS     - C++ structs and classes that are externally visible from a shared library. Corresponds to Microsoft __dllexport.
  # OVR_PRIVATE_FUNCTION - Functions that are not visible outside of a shared library. They are private to the shared library.
  # OVR_PRIVATE_CLASS    - C++ structs and classes that are not visible outside of a shared library. They are private to the shared library.
  #
  # OVR_DLL_BUILD        - Used to indicate that the current compilation unit is of a shared library.
  # OVR_DLL_IMPORT       - Used to indicate that the current compilation unit is a user of the corresponding shared library.
  # OVR_DLL_BUILD        - used to indicate that the current compilation unit is not a shared library but rather statically linked code.
  #
  #-----------------------------------------------------------------------------------
  # ***** OVR_EXPORT
  #
  # Provided for backward compatibility with older usage.
  #-----------------------------------------------------------------------------------
  # ***** OVR_ALIGNAS
  #
  #-----------------------------------------------------------------------------------
  # ***** ovrBool
  type 
    ovrBool* = char
  const 
    ovrFalse* = 0
    ovrTrue* = 1
  #-----------------------------------------------------------------------------------
  # ***** Simple Math Structures
  #/ A 2D vector with integer components.
  type 
    ovrVector2i* {.importc: "ovrVector2i", header: "OVR_CAPI_0_5_0_modified.h".} = object 
      x* {.importc: "x".}: cint
      y* {.importc: "y".}: cint

  #/ A 2D size with integer components.
  type 
    ovrSizei* {.importc: "ovrSizei", header: "OVR_CAPI_0_5_0_modified.h".} = object 
      w* {.importc: "w".}: cint
      h* {.importc: "h".}: cint

  #/ A 2D rectangle with a position and size.
  #/ All components are integers.
  type 
    ovrRecti* {.importc: "ovrRecti", header: "OVR_CAPI_0_5_0_modified.h".} = object 
      Pos* {.importc: "Pos".}: ovrVector2i
      Size* {.importc: "Size".}: ovrSizei

  #/ A quaternion rotation.
  type 
    ovrQuatf* {.importc: "ovrQuatf", header: "OVR_CAPI_0_5_0_modified.h".} = object 
      x* {.importc: "x".}: cfloat
      y* {.importc: "y".}: cfloat
      z* {.importc: "z".}: cfloat
      w* {.importc: "w".}: cfloat

  #/ A 2D vector with float components.
  type 
    ovrVector2f* {.importc: "ovrVector2f", header: "OVR_CAPI_0_5_0_modified.h".} = object 
      x* {.importc: "x".}: cfloat
      y* {.importc: "y".}: cfloat

  #/ A 3D vector with float components.
  type 
    ovrVector3f* {.importc: "ovrVector3f", header: "OVR_CAPI_0_5_0_modified.h".} = object 
      x* {.importc: "x".}: cfloat
      y* {.importc: "y".}: cfloat
      z* {.importc: "z".}: cfloat

  #/ A 4x4 matrix with float elements.
  type 
    ovrMatrix4f* {.importc: "ovrMatrix4f", header: "OVR_CAPI_0_5_0_modified.h".} = object 
      M* {.importc: "M".}: array[4, array[4, cfloat]]

  #/ Position and orientation together.
  type 
    ovrPosef* {.importc: "ovrPosef", header: "OVR_CAPI_0_5_0_modified.h".} = object 
      Orientation* {.importc: "Orientation".}: ovrQuatf
      Position* {.importc: "Position".}: ovrVector3f

  #/ A full pose (rigid body) configuration with first and second derivatives.
  type 
    ovrPoseStatef* {.importc: "ovrPoseStatef", 
                     header: "OVR_CAPI_0_5_0_modified.h".} = object 
      ThePose* {.importc: "ThePose".}: ovrPosef #/< The body's position and orientation.
      AngularVelocity* {.importc: "AngularVelocity".}: ovrVector3f #/< The body's angular velocity in radians per second.
      LinearVelocity* {.importc: "LinearVelocity".}: ovrVector3f #/< The body's velocity in meters per second.
      AngularAcceleration* {.importc: "AngularAcceleration".}: ovrVector3f #/< The body's angular acceleration in radians per second per second.
      LinearAcceleration* {.importc: "LinearAcceleration".}: ovrVector3f #/< The body's acceleration in meters per second per second.
      Pad* {.importc: "Pad".}: cfloat #/< Unused struct padding.
      TimeInSeconds* {.importc: "TimeInSeconds".}: cdouble #/< Absolute time of this state sample.
    
  #/ Field Of View (FOV) in tangent of the angle units.
  #/ As an example, for a standard 90 degree vertical FOV, we would
  #/ have: { UpTan = tan(90 degrees / 2), DownTan = tan(90 degrees / 2) }.
  type 
    ovrFovPort* {.importc: "ovrFovPort", header: "OVR_CAPI_0_5_0_modified.h".} = object 
      UpTan* {.importc: "UpTan".}: cfloat #/< The tangent of the angle between the viewing vector and the top edge of the field of view.
      DownTan* {.importc: "DownTan".}: cfloat #/< The tangent of the angle between the viewing vector and the bottom edge of the field of view.
      LeftTan* {.importc: "LeftTan".}: cfloat #/< The tangent of the angle between the viewing vector and the left edge of the field of view.
      RightTan* {.importc: "RightTan".}: cfloat #/< The tangent of the angle between the viewing vector and the right edge of the field of view.
    
  #-----------------------------------------------------------------------------------
  # ***** HMD Types
  #/ Enumerates all HMD types that we support.
  type 
    ovrHmdType* {.size: sizeof(cint).} = enum 
      ovrHmd_None = 0, ovrHmd_DK1 = 3, ovrHmd_DKHD = 4, ovrHmd_DK2 = 6, 
      ovrHmd_BlackStar = 7, ovrHmd_CB = 8, ovrHmd_Other = 9, 
      ovrHmd_EnumSize = 0x7FFFFFFF
  #/ HMD capability bits reported by device.
  type                        # Read-only flags.
    ovrHmdCaps* {.size: sizeof(cint).} = enum 
      ovrHmdCap_Present = 0x00000001, #/< (read only) The HMD is plugged in and detected by the system.
      ovrHmdCap_Available = 0x00000002, #/< (read only) The HMD and its sensor are available for ownership use.
                                        #/<             i.e. it is not already owned by another application.
      ovrHmdCap_Captured = 0x00000004, #/< (read only) Set to 'true' if we captured ownership of this HMD.
      ovrHmdCap_ExtendDesktop = 0x00000008, #/< (read only) Means the display driver works via acting as an addition display monitor.
      ovrHmdCap_DebugDevice = 0x00000010, #/< (read only) Means HMD device is a virtual debug device.
                                          # Modifiable flags (through ovrHmd_SetEnabledCaps).
      ovrHmdCap_DisplayOff = 0x00000040, #/< Turns off HMD screen and output (only if 'ExtendDesktop' is off).
      ovrHmdCap_LowPersistence = 0x00000080, #/< HMD supports low persistence mode.
      ovrHmdCap_DynamicPrediction = 0x00000200, #/< Adjust prediction dynamically based on internally measured latency.
      ovrHmdCap_NoVSync = 0x00001000, #/< Support rendering without VSync for debugging.
                                      # These bits can be modified by ovrHmd_SetEnabledCaps.
      ovrHmdCap_Writable_Mask = ovrHmdCap_NoMirrorToWindow or
          ovrHmdCap_DisplayOff or ovrHmdCap_LowPersistence or
          ovrHmdCap_DynamicPrediction or ovrHmdCap_NoVSync, #/ These flags are currently passed into the service. May change without notice.
      ovrHmdCap_Service_Mask = ovrHmdCap_NoMirrorToWindow or
          ovrHmdCap_DisplayOff or ovrHmdCap_LowPersistence or
          ovrHmdCap_DynamicPrediction, ovrHmdCap_NoMirrorToWindow = 0x00002000, #/< Disables mirroring of HMD output to the window. This may improve 
                                                                                #/< rendering performance slightly (only if 'ExtendDesktop' is off).
      ovrHmdCap_EnumSize = 0x7FFFFFFF
  #/ Tracking capability bits reported by the device.
  #/ Used with ovrHmd_ConfigureTracking.
  type 
    ovrTrackingCaps* {.size: sizeof(cint).} = enum 
      ovrTrackingCap_Orientation = 0x00000010, #/< Supports orientation tracking (IMU).
      ovrTrackingCap_MagYawCorrection = 0x00000020, #/< Supports yaw drift correction via a magnetometer or other means.
      ovrTrackingCap_Position = 0x00000040, #/< Supports positional tracking.
                                            #/ Overrides the other flags. Indicates that the application
                                            #/ doesn't care about tracking settings. This is the internal
                                            #/ default before ovrHmd_ConfigureTracking is called.
      ovrTrackingCap_Idle = 0x00000100, ovrTrackingCap_EnumSize = 0x7FFFFFFF
  #/ Distortion capability bits reported by device.
  #/ Used with ovrHmd_ConfigureRendering and ovrHmd_CreateDistortionMesh.
  type                        # 0x01 unused - Previously ovrDistortionCap_Chromatic now enabled permanently.
    ovrDistortionCaps* {.size: sizeof(cint).} = enum 
      ovrDistortionCap_TimeWarp = 0x00000002, #/< Supports timewarp.
                                              # 0x04 unused
      ovrDistortionCap_Vignette = 0x00000008, #/< Supports vignetting around the edges of the view.
      ovrDistortionCap_NoRestore = 0x00000010, #/< Do not save and restore the graphics and compute state when rendering distortion.
      ovrDistortionCap_FlipInput = 0x00000020, #/< Flip the vertical texture coordinate of input images.
      ovrDistortionCap_SRGB = 0x00000040, #/< Assume input images are in sRGB gamma-corrected color space.
      ovrDistortionCap_Overdrive = 0x00000080, #/< Overdrive brightness transitions to reduce artifacts on DK2+ displays
      ovrDistortionCap_HqDistortion = 0x00000100, #/< High-quality sampling of distortion buffer for anti-aliasing
      ovrDistortionCap_LinuxDevFullscreen = 0x00000200, #/< Indicates window is fullscreen on a device when set. The SDK will automatically apply distortion mesh rotation if needed.
      ovrDistortionCap_ComputeShader = 0x00000400, #/< Using compute shader (DX11+ only)
                                                   #ovrDistortionCap_NoTimewarpJit    =   0x800      RETIRED - do not reuse this bit without major versioning changes.
      ovrDistortionCap_TimewarpJitDelay = 0x00001000, #/< Enables a spin-wait that tries to push time-warp to be as close to V-sync as possible. WARNING - this may backfire and cause framerate loss - use with caution.
      ovrDistortionCap_ProfileNoSpinWaits = 0x00010000, #/< Use when profiling with timewarp to remove false positives
      ovrDistortionCap_EnumSize = 0x7FFFFFFF
  #/ Specifies which eye is being used for rendering.
  #/ This type explicitly does not include a third "NoStereo" option, as such is
  #/ not required for an HMD-centered API.
  type 
    ovrEyeType* {.size: sizeof(cint).} = enum 
      ovrEye_Left = 0, ovrEye_Right = 1, ovrEye_Count = 2, 
      ovrEye_EnumSize = 0x7FFFFFFF
  #/ This is a complete descriptor of the HMD.
  type 
    ovrHmdDesc* {.importc: "ovrHmdDesc", header: "OVR_CAPI_0_5_0_modified.h".} = object 
      Handle* {.importc: "Handle".}: ptr ovrHmdStruct #/ Internal handle of this HMD.
      #/ This HMD's type.
      Type* {.importc: "Type".}: ovrHmdType #/ Name string describing the product: "Oculus Rift DK1", etc.
      ProductName* {.importc: "ProductName".}: cstring #/ String describing the manufacturer. Usually "Oculus".
      Manufacturer* {.importc: "Manufacturer".}: cstring #/ HID Vendor ID of the device.
      VendorId* {.importc: "VendorId".}: cshort #/ HID Product ID of the device.
      ProductId* {.importc: "ProductId".}: cshort #/ Sensor (and display) serial number.
      SerialNumber* {.importc: "SerialNumber".}: array[24, char] #/ Sensor firmware major version number.
      FirmwareMajor* {.importc: "FirmwareMajor".}: cshort #/ Sensor firmware minor version number.
      FirmwareMinor* {.importc: "FirmwareMinor".}: cshort # External tracking camera frustum dimensions (if present).
      CameraFrustumHFovInRadians* {.importc: "CameraFrustumHFovInRadians".}: cfloat #/< Horizontal field-of-view
      CameraFrustumVFovInRadians* {.importc: "CameraFrustumVFovInRadians".}: cfloat #/< Vertical field-of-view
      CameraFrustumNearZInMeters* {.importc: "CameraFrustumNearZInMeters".}: cfloat #/< Near clip distance
      CameraFrustumFarZInMeters* {.importc: "CameraFrustumFarZInMeters".}: cfloat #/< Far clip distance
                                                                                  #/ Capability bits described by ovrHmdCaps.
      HmdCaps* {.importc: "HmdCaps".}: cuint #/ Capability bits described by ovrTrackingCaps.
      TrackingCaps* {.importc: "TrackingCaps".}: cuint #/ Capability bits described by ovrDistortionCaps.
      DistortionCaps* {.importc: "DistortionCaps".}: cuint #/ The recommended optical FOV for the HMD.
      DefaultEyeFov* {.importc: "DefaultEyeFov".}: array[ovrEye_Count, 
          ovrFovPort]         #/ The maximum optical FOV for the HMD.
      MaxEyeFov* {.importc: "MaxEyeFov".}: array[ovrEye_Count, ovrFovPort] #/ Preferred eye rendering order for best performance.
                                                                           #/ Can help reduce latency on sideways-scanned screens.
      EyeRenderOrder* {.importc: "EyeRenderOrder".}: array[ovrEye_Count, 
          ovrEyeType]         #/ Resolution of the full HMD screen (both eyes) in pixels.
      Resolution* {.importc: "Resolution".}: ovrSizei #/ Location of the application window on the desktop (or 0,0).
      WindowsPos* {.importc: "WindowsPos".}: ovrVector2i #/ Display that the HMD should present on.
                                                         #/ TBD: It may be good to remove this information relying on WindowPos instead.
                                                         #/ Ultimately, we may need to come up with a more convenient alternative,
                                                         #/ such as API-specific functions that return adapter, or something that will
                                                         #/ work with our monitor driver.
                                                         #/ Windows: (e.g. "\\\\.\\DISPLAY3", can be used in EnumDisplaySettings/CreateDC).
      DisplayDeviceName* {.importc: "DisplayDeviceName".}: cstring #/ MacOS:
      DisplayId* {.importc: "DisplayId".}: cint

  #/ Simple type ovrHmd is used in ovrHmd_* calls.
  type 
    ovrHmd* = ptr ovrHmdDesc
  #/ Bit flags describing the current status of sensor tracking.
  # The values must be the same as in enum StatusBits
  type 
    ovrStatusBits* {.size: sizeof(cint).} = enum 
      ovrStatus_OrientationTracked = 0x00000001, #/< Orientation is currently tracked (connected and in use).
      ovrStatus_PositionTracked = 0x00000002, #/< Position is currently tracked (false if out of range).
      ovrStatus_CameraPoseTracked = 0x00000004, #/< Camera pose is currently tracked.
      ovrStatus_PositionConnected = 0x00000020, #/< Position tracking hardware is connected.
      ovrStatus_HmdConnected = 0x00000080, #/< HMD Display is available and connected.
      ovrStatus_EnumSize = 0x7FFFFFFF
  #/ Specifies a reading we can query from the sensor.
  type 
    ovrSensorData* {.importc: "ovrSensorData", 
                     header: "OVR_CAPI_0_5_0_modified.h".} = object 
      Accelerometer* {.importc: "Accelerometer".}: ovrVector3f #/ Acceleration reading in m/s^2.
      Gyro* {.importc: "Gyro".}: ovrVector3f #/ Rotation rate in rad/s.
      Magnetometer* {.importc: "Magnetometer".}: ovrVector3f #/ Magnetic field in Gauss.
      Temperature* {.importc: "Temperature".}: cfloat #/ Temperature of the sensor in degrees Celsius.
      TimeInSeconds* {.importc: "TimeInSeconds".}: cfloat #/ Time when the reported IMU reading took place, in seconds.
    
  #/ Tracking state at a given absolute time (describes predicted HMD pose etc).
  #/ Returned by ovrHmd_GetTrackingState.
  type 
    ovrTrackingState* {.importc: "ovrTrackingState", 
                        header: "OVR_CAPI_0_5_0_modified.h".} = object 
      HeadPose* {.importc: "HeadPose".}: ovrPoseStatef #/ Predicted head pose (and derivatives) at the requested absolute time.
                                                       #/ The look-ahead interval is equal to (HeadPose.TimeInSeconds - RawSensorData.TimeInSeconds).
      #/ Current pose of the external camera (if present).
      #/ This pose includes camera tilt (roll and pitch). For a leveled coordinate
      #/ system use LeveledCameraPose.
      CameraPose* {.importc: "CameraPose".}: ovrPosef #/ Camera frame aligned with gravity.
                                                      #/ This value includes position and yaw of the camera, but not roll and pitch.
                                                      #/ It can be used as a reference point to render real-world objects in the correct location.
      LeveledCameraPose* {.importc: "LeveledCameraPose".}: ovrPosef #/ The most recent sensor data received from the HMD.
      RawSensorData* {.importc: "RawSensorData".}: ovrSensorData #/ Tracking status described by ovrStatusBits.
      StatusFlags* {.importc: "StatusFlags".}: cuint #/ Tag the vision processing results to a certain frame counter number.
      LastCameraFrameCounter* {.importc: "LastCameraFrameCounter".}: uint32_t #/ Unused struct padding.
      Pad* {.importc: "Pad".}: uint32_t

  #/ Frame timing data reported by ovrHmd_BeginFrameTiming() or ovrHmd_BeginFrame().
  type 
    ovrFrameTiming* {.importc: "ovrFrameTiming", 
                      header: "OVR_CAPI_0_5_0_modified.h".} = object 
      DeltaSeconds* {.importc: "DeltaSeconds".}: cfloat #/ The amount of time that has passed since the previous frame's
                                                        #/ ThisFrameSeconds value (usable for movement scaling).
                                                        #/ This will be clamped to no more than 0.1 seconds to prevent
                                                        #/ excessive movement after pauses due to loading or initialization.
      #/ Unused struct padding.
      Pad* {.importc: "Pad".}: cfloat #/ It is generally expected that the following holds:
                                      #/ ThisFrameSeconds < TimewarpPointSeconds < NextFrameSeconds < 
                                      #/ EyeScanoutSeconds[EyeOrder[0]] <= ScanoutMidpointSeconds <= EyeScanoutSeconds[EyeOrder[1]].
                                      #/ Absolute time value when rendering of this frame began or is expected to
                                      #/ begin. Generally equal to NextFrameSeconds of the previous frame. Can be used
                                      #/ for animation timing.
      ThisFrameSeconds* {.importc: "ThisFrameSeconds".}: cdouble #/ Absolute point when IMU expects to be sampled for this frame.
      TimewarpPointSeconds* {.importc: "TimewarpPointSeconds".}: cdouble #/ Absolute time when frame Present followed by GPU Flush will finish and the next frame begins.
      NextFrameSeconds* {.importc: "NextFrameSeconds".}: cdouble #/ Time when half of the screen will be scanned out. Can be passed as an absolute time
                                                                 #/ to ovrHmd_GetTrackingState() to get the predicted general orientation.
      ScanoutMidpointSeconds* {.importc: "ScanoutMidpointSeconds".}: cdouble #/ Timing points when each eye will be scanned out to display. Used when rendering each eye.
      EyeScanoutSeconds* {.importc: "EyeScanoutSeconds".}: array[2, cdouble]

  #/ Rendering information for each eye. Computed by either ovrHmd_ConfigureRendering()
  #/ or ovrHmd_GetRenderDesc() based on the specified FOV. Note that the rendering viewport
  #/ is not included here as it can be specified separately and modified per frame through:
  #/    (a) ovrHmd_GetRenderScaleAndOffset in the case of client rendered distortion,
  #/ or (b) passing different values via ovrTexture in the case of SDK rendered distortion.
  type 
    ovrEyeRenderDesc* {.importc: "ovrEyeRenderDesc", 
                        header: "OVR_CAPI_0_5_0_modified.h".} = object 
      Eye* {.importc: "Eye".}: ovrEyeType #/< The eye index this instance corresponds to.
      Fov* {.importc: "Fov".}: ovrFovPort #/< The field of view.
      DistortedViewport* {.importc: "DistortedViewport".}: ovrRecti #/< Distortion viewport.
      PixelsPerTanAngleAtCenter* {.importc: "PixelsPerTanAngleAtCenter".}: ovrVector2f #/< How many display pixels will fit in tan(angle) = 1.
      HmdToEyeViewOffset* {.importc: "HmdToEyeViewOffset".}: ovrVector3f #/< Translation to be applied to view matrix for each eye offset.
    
  #/ Rendering information for positional TimeWarp.
  #/ Contains the data necessary to properly calculate position info for timewarp matrices
  #/ and also interpret depth info provided via the depth buffer to the timewarp shader
  type 
    ovrPositionTimewarpDesc* {.importc: "ovrPositionTimewarpDesc", 
                               header: "OVR_CAPI_0_5_0_modified.h".} = object 
      HmdToEyeViewOffset* {.importc: "HmdToEyeViewOffset".}: array[2, 
          ovrVector3f]        #/ The same offset value pair provided in ovrEyeRenderDesc.
      #/ The near clip distance used in the projection matrix.
      NearClip* {.importc: "NearClip".}: cfloat #/ The far clip distance used in the projection matrix
                                                #/ utilized when rendering the eye depth textures provided in ovrHmd_EndFrame
      FarClip* {.importc: "FarClip".}: cfloat

  #-----------------------------------------------------------------------------------
  # ***** Platform-independent Rendering Configuration
  #/ These types are used to hide platform-specific details when passing
  #/ render device, OS, and texture data to the API.
  #/
  #/ The benefit of having these wrappers versus platform-specific API functions is
  #/ that they allow game glue code to be portable. A typical example is an
  #/ engine that has multiple back ends, say GL and D3D. Portable code that calls
  #/ these back ends may also use LibOVR. To do this, back ends can be modified
  #/ to return portable types such as ovrTexture and ovrRenderAPIConfig.
  type 
    ovrRenderAPIType* {.size: sizeof(cint).} = enum 
      ovrRenderAPI_None, ovrRenderAPI_OpenGL, ovrRenderAPI_Android_GLES, # May include extra native window 
                                                                         # pointers, etc.
      ovrRenderAPI_D3D9,      # Deprecated: Not supported for SDK rendering
      ovrRenderAPI_D3D10,     # Deprecated: Not supported for SDK rendering
      ovrRenderAPI_D3D11, ovrRenderAPI_Count, ovrRenderAPI_EnumSize = 0x7FFFFFFF
  #/ Platform-independent part of rendering API-configuration data.
  #/ It is a part of ovrRenderAPIConfig, passed to ovrHmd_Configure.
  type 
    ovrRenderAPIConfigHeader* {.importc: "ovrRenderAPIConfigHeader", 
                                header: "OVR_CAPI_0_5_0_modified.h".} = object 
      API* {.importc: "API".}: ovrRenderAPIType #/< The graphics API in use.
      BackBufferSize* {.importc: "BackBufferSize".}: ovrSizei #/< Previously named RTSize.
      Multisample* {.importc: "Multisample".}: cint #/< The number of samples per pixel.
    
  #/ Contains platform-specific information for rendering.
  type 
    ovrRenderAPIConfig* {.importc: "ovrRenderAPIConfig", 
                          header: "OVR_CAPI_0_5_0_modified.h".} = object 
      Header* {.importc: "Header".}: ovrRenderAPIConfigHeader #/< Platform-independent rendering information.
      PlatformData* {.importc: "PlatformData".}: array[8, uintptr_t] #/< Platform-specific rendering information.
    
  #/ Platform-independent part of the eye texture descriptor.
  #/ It is a part of ovrTexture, passed to ovrHmd_EndFrame.
  #/ If RenderViewport is all zeros then the full texture will be used.
  type 
    ovrTextureHeader* {.importc: "ovrTextureHeader", 
                        header: "OVR_CAPI_0_5_0_modified.h".} = object 
      API* {.importc: "API".}: ovrRenderAPIType #/< The graphics API in use.
      TextureSize* {.importc: "TextureSize".}: ovrSizei #/< The size of the texture.
      RenderViewport* {.importc: "RenderViewport".}: ovrRecti #/< Pixel viewport in texture that holds eye image.
    
  #/ Contains platform-specific information about a texture.
  #/ Specialized for different rendering APIs in:
  #/     ovrGLTexture, ovrD3D11Texture
  type 
    ovrTexture* {.importc: "ovrTexture", header: "OVR_CAPI_0_5_0_modified.h".} = object 
      Header* {.importc: "Header".}: ovrTextureHeader #/< Platform-independent data about the texture.
      PlatformData* {.importc: "PlatformData".}: array[8, uintptr_t] #/< Specialized in ovrGLTextureData, ovrD3D11TextureData etc.
    
  # 
  # -----------------------------------------------------------------------------------
  # ***** API Interfaces
  # Basic steps to use the API:
  #
  # Setup:
  #  * ovrInitialize()
  #  * ovrHMD hmd = ovrHmd_Create(0)
  #  * Use hmd members and ovrHmd_GetFovTextureSize() to determine graphics configuration.
  #  * Call ovrHmd_ConfigureTracking() to configure and initialize tracking.
  #  * Call ovrHmd_ConfigureRendering() to setup graphics for SDK rendering,
  #    which is the preferred approach.
  #    Please refer to "Client Distortion Rendering" below if you prefer to do that instead.
  #  * If the ovrHmdCap_ExtendDesktop flag is not set, then use ovrHmd_AttachToWindow to
  #    associate the relevant application window with the hmd.
  #  * Allocate render target textures as needed.
  #
  # Game Loop:
  #  * Call ovrHmd_BeginFrame() to get the current frame timing information.
  #  * Render each eye using ovrHmd_GetEyePoses() to get each eye pose.
  #  * Call ovrHmd_EndFrame() to render the distorted textures to the back buffer
  #    and present them on the hmd.
  #
  # Shutdown:
  #  * ovrHmd_Destroy(hmd)
  #  * ovr_Shutdown()
  #
  #/ ovr_InitializeRenderingShim initializes the rendering shim apart from everything
  #/ else in LibOVR. This may be helpful if the application prefers to avoid
  #/ creating any OVR resources (allocations, service connections, etc) at this point.
  #/ ovr_InitializeRenderingShim does not bring up anything within LibOVR except the
  #/ necessary hooks to enable the Direct-to-Rift functionality.
  #/
  #/ Either ovr_InitializeRenderingShim() or ovr_Initialize() must be called before any
  #/ Direct3D or OpenGL initialization is done by application (creation of devices, etc).
  #/ ovr_Initialize() must still be called after to use the rest of LibOVR APIs.
  #/
  #/ Same as ovr_InitializeRenderingShim except it requests to support at least the
  #/ given minor LibOVR library version.
  ovr_InitializeRenderingShimVersion(int, requestedMinorVersion)
  ovr_InitializeRenderingShim()
  #/ Library init/shutdown, must be called around all other OVR code.
  #/ No other functions calls besides ovr_InitializeRenderingShim are allowed before
  #/ ovr_Initialize succeeds or after ovr_Shutdown.
  #/ Initializes all Oculus functionality.
  #/ A second call to ovr_Initialize after successful second call returns ovrTrue.
  #/ Flags for Initialize()
  type # When a debug library is requested, a slower debugging version of the library will
       # be run which can be used to help solve problems in the library and debug game code.
    ovrInitFlags* {.size: sizeof(cint).} = enum 
      ovrInit_Debug = 0x00000001, # When ServerOptional is set, the ovr_Initialize() call not will block waiting for
                                  # the server to respond.  If the server is not reachable it may still succeed.
      ovrInit_ServerOptional = 0x00000002, # When a version is requested, LibOVR runtime will respect the RequestedMinorVersion
                                           # field and will verify that the RequestedMinorVersion is supported.
      ovrInit_RequestVersion = 0x00000004, # Forces debug features of LibOVR off explicitly, even if it is built in debug mode.
      ovrInit_ForceNoDebug = 0x00000008
  #/ Logging levels
  type 
    ovrLogLevel* {.size: sizeof(cint).} = enum 
      ovrLogLevel_Debug = 0, ovrLogLevel_Info = 1, ovrLogLevel_Error = 2
  #/ Signature for the logging callback.
  #/ Level is one of the ovrLogLevel constants.
  type 
    ovrLogCallback* = proc (level: cint; message: cstring) {.cdecl.}
  #/ Parameters for the ovr_Initialize() call.
  type 
    ovrInitParams* {.importc: "ovrInitParams", 
                     header: "OVR_CAPI_0_5_0_modified.h".} = object 
      Flags* {.importc: "Flags".}: uint32_t #/ Flags from ovrInitFlags to override default behavior.
                                            #/ Pass 0 for the defaults.
      #/< Combination of ovrInitFlags or 0
      #/ Request a specific minimum minor version of the LibOVR runtime.
      #/ Flags must include ovrInit_RequestVersion or this will be ignored.
      RequestedMinorVersion* {.importc: "RequestedMinorVersion".}: uint32_t #/ Log callback function, which may be called at any time asynchronously from
                                                                            #/ multiple threads until ovr_Shutdown() completes.
                                                                            #/ Pass 0 for no log callback.
      LogCallback* {.importc: "LogCallback".}: ovrLogCallback #/< Function pointer or 0
                                                              #/ Number of milliseconds to wait for a connection to the server.
                                                              #/ Pass 0 for the default timeout.
      ConnectionTimeoutMS* {.importc: "ConnectionTimeoutMS".}: uint32_t #/< Timeout in Milliseconds or 0
    
  #/ Initialize with extra parameters.
  #/ Pass 0 to initialize with default parameters, suitable for released games.
  #/ LibOVRRT shared library search order:
  #/      1) Current working directory (often the same as the application directory).
  #/      2) Module directory (usually the same as the application directory, but not if the module is a separate shared library).
  #/      3) Application directory
  #/      4) Development directory (only if OVR_ENABLE_DEVELOPER_SEARCH is enabled, which is off by default).
  #/      5) Standard OS shared library search location(s) (OS-specific).
  ovr_Initialize(ovrInitParams, `const` * params)
  #/ Shuts down all Oculus functionality.
  ovr_Shutdown()
  #/ Returns version string representing libOVR version. Static, so
  #/ string remains valid for app lifespan
  ovr_GetVersionString()
  #/ Detects or re-detects HMDs and reports the total number detected.
  #/ Users can get information about each HMD by calling ovrHmd_Create with an index.
  #/ Returns -1 when the service is unreachable.
  ovrHmd_Detect()
  #/ Creates a handle to an HMD which doubles as a description structure.
  #/ Index can [0 .. ovrHmd_Detect()-1]. Index mappings can cange after each ovrHmd_Detect call.
  #/ If not null, then the returned handle must be freed with ovrHmd_Destroy.
  ovrHmd_Create(int, index)
  ovrHmd_Destroy(ovrHmd, hmd)
  #/ Creates a 'fake' HMD used for debugging only. This is not tied to specific hardware,
  #/ but may be used to debug some of the related rendering.
  ovrHmd_CreateDebug(ovrHmdType, `type`)
  #/ Returns last error for HMD state. Returns null for no error.
  #/ String is valid until next call or GetLastError or HMD is destroyed.
  #/ Pass null hmd to get global errors (during create etc).
  ovrHmd_GetLastError(ovrHmd, hmd)
  #/ Platform specific function to specify the application window whose output will be 
  #/ displayed on the HMD. Only used if the ovrHmdCap_ExtendDesktop flag is false.
  #/   Windows: SwapChain associated with this window will be displayed on the HMD.
  #/            Specify 'destMirrorRect' in window coordinates to indicate an area
  #/            of the render target output that will be mirrored from 'sourceRenderTargetRect'.
  #/            Null pointers mean "full size".
  #/ @note Source and dest mirror rects are not yet implemented.
  ovrHmd_AttachToWindow(ovrHmd, hmd, void * window, `const`, 
                        ovrRecti * destMirrorRect, `const`, 
                        ovrRecti * sourceRenderTargetRect)
  #/ Returns capability bits that are enabled at this time as described by ovrHmdCaps.
  #/ Note that this value is different font ovrHmdDesc::HmdCaps, which describes what
  #/ capabilities are available for that HMD.
  ovrHmd_GetEnabledCaps(ovrHmd, hmd)
  #/ Modifies capability bits described by ovrHmdCaps that can be modified,
  #/ such as ovrHmdCap_LowPersistance.
  ovrHmd_SetEnabledCaps(ovrHmd, hmd, unsigned, int, hmdCaps)
  #-------------------------------------------------------------------------------------
  # ***** Tracking Interface
  #/ All tracking interface functions are thread-safe, allowing tracking state to be sampled
  #/ from different threads.
  #/ ConfigureTracking starts sensor sampling, enabling specified capabilities,
  #/    described by ovrTrackingCaps.
  #/  - supportedTrackingCaps specifies support that is requested. The function will succeed
  #/   even if these caps are not available (i.e. sensor or camera is unplugged). Support
  #/    will automatically be enabled if such device is plugged in later. Software should
  #/    check ovrTrackingState.StatusFlags for real-time status.
  #/  - requiredTrackingCaps specify sensor capabilities required at the time of the call.
  #/    If they are not available, the function will fail. Pass 0 if only specifying
  #/    supportedTrackingCaps.
  #/  - Pass 0 for both supportedTrackingCaps and requiredTrackingCaps to disable tracking.
  ovrHmd_ConfigureTracking(ovrHmd, hmd, unsigned, int, supportedTrackingCaps, 
                           unsigned, int, requiredTrackingCaps)
  #/ Re-centers the sensor orientation.
  #/ Normally this will recenter the (x,y,z) translational components and the yaw
  #/ component of orientation.
  ovrHmd_RecenterPose(ovrHmd, hmd)
  #/ Returns tracking state reading based on the specified absolute system time.
  #/ Pass an absTime value of 0.0 to request the most recent sensor reading. In this case
  #/ both PredictedPose and SamplePose will have the same value.
  #/ ovrHmd_GetEyePoses relies on a valid ovrTrackingState.
  #/ This may also be used for more refined timing of FrontBuffer rendering logic, etc.
  ovrHmd_GetTrackingState(ovrHmd, hmd, double, absTime)
  #-------------------------------------------------------------------------------------
  # ***** Graphics Setup
  #/ Calculates the recommended viewport size for rendering a given eye within the HMD
  #/ with a given FOV cone. Higher FOV will generally require larger textures to
  #/ maintain quality.
  #/  - pixelsPerDisplayPixel specifies the ratio of the number of render target pixels
  #/    to display pixels at the center of distortion. 1.0 is the default value. Lower
  #/    values can improve performance, higher values give improved quality.
  #/ Apps packing multiple eye views together on the same textue should ensure there is
  #/ roughly 8 pixels of padding between them to prevent texture filtering and chromatic
  #/ aberration causing images to "leak" between the two eye views.
  ovrHmd_GetFovTextureSize(ovrHmd, hmd, ovrEyeType, eye, ovrFovPort, fov, float, 
                           pixelsPerDisplayPixel)
  #-------------------------------------------------------------------------------------
  # *****  Rendering API Thread Safety
  #  All of rendering functions including the configure and frame functions
  # are *NOT thread safe*. It is ok to use ConfigureRendering on one thread and handle
  #  frames on another thread, but explicit synchronization must be done since
  #  functions that depend on configured state are not reentrant.
  #
  #  As an extra requirement, any of the following calls must be done on
  #  the render thread, which is the same thread that calls ovrHmd_BeginFrame
  #  or ovrHmd_BeginFrameTiming.
  #    - ovrHmd_EndFrame
  #    - ovrHmd_GetEyeTimewarpMatrices
  #-------------------------------------------------------------------------------------
  # *****  SDK Distortion Rendering Functions
  # These functions support rendering of distortion by the SDK through direct
  # access to the underlying rendering API, such as D3D or GL.
  # This is the recommended approach since it allows better support for future
  # Oculus hardware, and enables a range of low-level optimizations.
  #/ Configures rendering and fills in computed render parameters.
  #/ This function can be called multiple times to change rendering settings.
  #/ eyeRenderDescOut is a pointer to an array of two ovrEyeRenderDesc structs
  #/ that are used to return complete rendering information for each eye.
  #/  - apiConfig provides D3D/OpenGL specific parameters. Pass null
  #/    to shutdown rendering and release all resources.
  #/  - distortionCaps describe desired distortion settings.
  ovrHmd_ConfigureRendering(ovrHmd, hmd, `const`, 
                            ovrRenderAPIConfig * apiConfig, unsigned, int, 
                            distortionCaps, `const`, ovrFovPort, eyeFovIn[2], 
                            ovrEyeRenderDesc, eyeRenderDescOut[2])
  #/ Begins a frame, returning timing information.
  #/ This should be called at the beginning of the game rendering loop (on the render thread).
  #/ Pass 0 for the frame index if not using ovrHmd_GetFrameTiming.
  ovrHmd_BeginFrame(ovrHmd, hmd, unsigned, int, frameIndex)
  #/ Ends a frame, submitting the rendered textures to the frame buffer.
  #/ - RenderViewport within each eyeTexture can change per frame if necessary.
  #/ - 'renderPose' will typically be the value returned from ovrHmd_GetEyePoses
  #/   but can be different if a different head pose was used for rendering.
  #/ - This may perform distortion and scaling internally, assuming is it not
  #/   delegated to another thread.
  #/ - Must be called on the same thread as BeginFrame.
  #/ - If ovrDistortionCap_DepthProjectedTimeWarp is enabled, then app must provide eyeDepthTexture
  #/   and posTimewarpDesc. Otherwise both can be NULL.
  #/ - *** This Function will call Present/SwapBuffers and potentially wait for GPU Sync ***.
  ovrHmd_EndFrame(ovrHmd, hmd, `const`, ovrPosef, renderPose[2], `const`, 
                  ovrTexture, eyeTexture[2])
  #/ Returns predicted head pose in outHmdTrackingState and offset eye poses in outEyePoses
  #/ as an atomic operation. Caller need not worry about applying HmdToEyeViewOffset to the
  #/ returned outEyePoses variables.
  #/ - Thread-safe function where caller should increment frameIndex with every frame
  #/   and pass the index where applicable to functions called on the  rendering thread.
  #/ - hmdToEyeViewOffset[2] can be ovrEyeRenderDesc.HmdToEyeViewOffset returned from 
  #/   ovrHmd_ConfigureRendering or ovrHmd_GetRenderDesc. For monoscopic rendering,
  #/   use a vector that is the average of the two vectors for both eyes.
  #/ - If frameIndex is not being utilized, pass in 0.
  #/ - Assuming outEyePoses are used for rendering, it should be passed into ovrHmd_EndFrame.
  #/ - If caller doesn't need outHmdTrackingState, it can be passed in as NULL
  ovrHmd_GetEyePoses(ovrHmd, hmd, unsigned, int, frameIndex, `const`, 
                     ovrVector3f, hmdToEyeViewOffset[2], ovrPosef, 
                     outEyePoses[2], ovrTrackingState * outHmdTrackingState)
  #/ Function was previously called ovrHmd_GetEyePose
  #/ Returns the predicted head pose to use when rendering the specified eye.
  #/ - Important: Caller must apply HmdToEyeViewOffset before using ovrPosef for rendering
  #/ - Must be called between ovrHmd_BeginFrameTiming and ovrHmd_EndFrameTiming.
  #/ - If returned pose is used for rendering the eye, it should be passed to ovrHmd_EndFrame.
  #/ - Parameter 'eye' is used internally for prediction timing only
  ovrHmd_GetHmdPosePerEye(ovrHmd, hmd, ovrEyeType, eye)
  #-------------------------------------------------------------------------------------
  # *****  Client Distortion Rendering Functions
  # These functions provide the distortion data and render timing support necessary to allow
  # client rendering of distortion. Client-side rendering involves the following steps:
  #
  #  1. Setup ovrEyeDesc based on the desired texture size and FOV.
  #     Call ovrHmd_GetRenderDesc to get the necessary rendering parameters for each eye.
  #
  #  2. Use ovrHmd_CreateDistortionMesh to generate the distortion mesh.
  #
  #  3. Use ovrHmd_BeginFrameTiming, ovrHmd_GetEyePoses, and ovrHmd_BeginFrameTiming in
  #     the rendering loop to obtain timing and predicted head orientation when rendering each eye.
  #      - When using timewarp, use ovr_WaitTillTime after the rendering and gpu flush, followed
  #        by ovrHmd_GetEyeTimewarpMatrices to obtain the timewarp matrices used
  #        by the distortion pixel shader. This will minimize latency.
  #
  #/ Computes the distortion viewport, view adjust, and other rendering parameters for
  #/ the specified eye. This can be used instead of ovrHmd_ConfigureRendering to do
  #/ setup for client rendered distortion.
  ovrHmd_GetRenderDesc(ovrHmd, hmd, ovrEyeType, eyeType, ovrFovPort, fov)
  #/ Describes a vertex used by the distortion mesh. This is intended to be converted into
  #/ the engine-specific format. Some fields may be unused based on the ovrDistortionCaps
  #/ flags selected. TexG and TexB, for example, are not used if chromatic correction is
  #/ not requested.
  type 
    ovrDistortionVertex* {.importc: "ovrDistortionVertex", 
                           header: "OVR_CAPI_0_5_0_modified.h".} = object 
      ScreenPosNDC* {.importc: "ScreenPosNDC".}: ovrVector2f #/< [-1,+1],[-1,+1] over the entire framebuffer.
      TimeWarpFactor* {.importc: "TimeWarpFactor".}: cfloat #/< Lerp factor between time-warp matrices. Can be encoded in Pos.z.
      VignetteFactor* {.importc: "VignetteFactor".}: cfloat #/< Vignette fade factor. Can be encoded in Pos.w.
      TanEyeAnglesR* {.importc: "TanEyeAnglesR".}: ovrVector2f #/< The tangents of the horizontal and vertical eye angles for the red channel.
      TanEyeAnglesG* {.importc: "TanEyeAnglesG".}: ovrVector2f #/< The tangents of the horizontal and vertical eye angles for the green channel.
      TanEyeAnglesB* {.importc: "TanEyeAnglesB".}: ovrVector2f #/< The tangents of the horizontal and vertical eye angles for the blue channel.
    
  #/ Describes a full set of distortion mesh data, filled in by ovrHmd_CreateDistortionMesh.
  #/ Contents of this data structure, if not null, should be freed by ovrHmd_DestroyDistortionMesh.
  type 
    ovrDistortionMesh* {.importc: "ovrDistortionMesh", 
                         header: "OVR_CAPI_0_5_0_modified.h".} = object 
      pVertexData* {.importc: "pVertexData".}: ptr ovrDistortionVertex #/< The distortion vertices representing each point in the mesh.
      pIndexData* {.importc: "pIndexData".}: ptr cushort #/< Indices for connecting the mesh vertices into polygons.
      VertexCount* {.importc: "VertexCount".}: cuint #/< The number of vertices in the mesh.
      IndexCount* {.importc: "IndexCount".}: cuint #/< The number of indices in the mesh.
    
  #/ Generate distortion mesh per eye.
  #/ Distortion capabilities will depend on 'distortionCaps' flags. Users should 
  #/ render using the appropriate shaders based on their settings.
  #/ Distortion mesh data will be allocated and written into the ovrDistortionMesh data structure,
  #/ which should be explicitly freed with ovrHmd_DestroyDistortionMesh.
  #/ Users should call ovrHmd_GetRenderScaleAndOffset to get uvScale and Offset values for rendering.
  #/ The function shouldn't fail unless theres is a configuration or memory error, in which case
  #/ ovrDistortionMesh values will be set to null.
  #/ This is the only function in the SDK reliant on eye relief, currently imported from profiles,
  #/ or overridden here.
  ovrHmd_CreateDistortionMesh(ovrHmd, hmd, ovrEyeType, eyeType, ovrFovPort, fov, 
                              unsigned, int, distortionCaps, 
                              ovrDistortionMesh * meshData)
  ovrHmd_CreateDistortionMeshDebug(ovrHmd, hmddesc, ovrEyeType, eyeType, 
                                   ovrFovPort, fov, unsigned, int, 
                                   distortionCaps, ovrDistortionMesh * meshData, 
                                   float, debugEyeReliefOverrideInMetres)
  #/ Used to free the distortion mesh allocated by ovrHmd_GenerateDistortionMesh. meshData elements
  #/ are set to null and zeroes after the call.
  ovrHmd_DestroyDistortionMesh(ovrDistortionMesh * meshData)
  #/ Computes updated 'uvScaleOffsetOut' to be used with a distortion if render target size or
  #/ viewport changes after the fact. This can be used to adjust render size every frame if desired.
  ovrHmd_GetRenderScaleAndOffset(ovrFovPort, fov, ovrSizei, textureSize, 
                                 ovrRecti, renderViewport, ovrVector2f, 
                                 uvScaleOffsetOut[2])
  #/ Thread-safe timing function for the main thread. Caller should increment frameIndex
  #/ with every frame and pass the index where applicable to functions called on the
  #/ rendering thread.
  ovrHmd_GetFrameTiming(ovrHmd, hmd, unsigned, int, frameIndex)
  #/ Called at the beginning of the frame on the rendering thread.
  #/ Pass frameIndex == 0 if ovrHmd_GetFrameTiming isn't being used. Otherwise,
  #/ pass the same frame index as was used for GetFrameTiming on the main thread.
  ovrHmd_BeginFrameTiming(ovrHmd, hmd, unsigned, int, frameIndex)
  #/ Marks the end of client distortion rendered frame, tracking the necessary timing information.
  #/ This function must be called immediately after Present/SwapBuffers + GPU sync. GPU sync is
  #/ important before this call to reduce latency and ensure proper timing.
  ovrHmd_EndFrameTiming(ovrHmd, hmd)
  #/ Initializes and resets frame time tracking. This is typically not necessary, but
  #/ is helpful if game changes vsync state or video mode. vsync is assumed to be on if this
  #/ isn't called. Resets internal frame index to the specified number.
  ovrHmd_ResetFrameTiming(ovrHmd, hmd, unsigned, int, frameIndex)
  #/ Computes timewarp matrices used by distortion mesh shader, these are used to adjust
  #/ for head orientation change since the last call to ovrHmd_GetEyePoses
  #/ when rendering this eye. The ovrDistortionVertex::TimeWarpFactor is used to blend between the
  #/ matrices, usually representing two different sides of the screen.
  #/ Set 'calcPosition' to true when using depth based positional timewarp
  #/ Must be called on the same thread as ovrHmd_BeginFrameTiming.
  ovrHmd_GetEyeTimewarpMatrices(ovrHmd, hmd, ovrEyeType, eye, ovrPosef, 
                                renderPose, ovrMatrix4f, twmOut[2])
  ovrHmd_GetEyeTimewarpMatricesDebug(ovrHmd, hmddesc, ovrEyeType, eye, ovrPosef, 
                                     renderPose, ovrQuatf, playerTorsoMotion, 
                                     ovrMatrix4f, twmOut[2], double, 
                                     debugTimingOffsetInSeconds)
  #-------------------------------------------------------------------------------------
  # ***** Stateless math setup functions
  #/ Returns global, absolute high-resolution time in seconds. This is the same
  #/ value as used in sensor messages.
  ovr_GetTimeInSeconds()
  # 
  # -----------------------------------------------------------------------------------
  # ***** Latency Test interface
  #/ Does latency test processing and returns 'TRUE' if specified rgb color should
  #/ be used to clear the screen.
  ovrHmd_ProcessLatencyTest(ovrHmd, hmd, unsigned, char, rgbColorOut[3])
  #/ Returns non-null string once with latency test result, when it is available.
  #/ Buffer is valid until next call.
  ovrHmd_GetLatencyTestResult(ovrHmd, hmd)
  #/ Returns the latency testing color in rgbColorOut to render when using a DK2
  #/ Returns false if this feature is disabled or not-applicable (e.g. using a DK1)
  ovrHmd_GetLatencyTest2DrawColor(ovrHmd, hmddesc, unsigned, char, 
                                  rgbColorOut[3])
  #-------------------------------------------------------------------------------------
  # ***** Health and Safety Warning Display interface
  #
  #/ Used by ovrhmd_GetHSWDisplayState to report the current display state.
  type 
    ovrHSWDisplayState* {.importc: "ovrHSWDisplayState", 
                          header: "OVR_CAPI_0_5_0_modified.h".} = object 
      Displayed* {.importc: "Displayed".}: ovrBool #/ If true then the warning should be currently visible
                                                   #/ and the following variables have meaning. Else there is no
                                                   #/ warning being displayed for this application on the given HMD.
      #/< True if the Health&Safety Warning is currently displayed.
      Pad* {.importc: "Pad".}: array[8 - sizeof((ovrBool)), char] #/< Unused struct padding.
      StartTime* {.importc: "StartTime".}: cdouble #/< Absolute time when the warning was first displayed. See ovr_GetTimeInSeconds().
      DismissibleTime* {.importc: "DismissibleTime".}: cdouble #/< Earliest absolute time when the warning can be dismissed. May be a time in the past.
    
  #/ Returns the current state of the HSW display. If the application is doing the rendering of
  #/ the HSW display then this function serves to indicate that the warning should be
  #/ currently displayed. If the application is using SDK-based eye rendering then the SDK by
  #/ default automatically handles the drawing of the HSW display. An application that uses
  #/ application-based eye rendering should use this function to know when to start drawing the
  #/ HSW display itself and can optionally use it in conjunction with ovrhmd_DismissHSWDisplay
  #/ as described below.
  #/
  #/ Example usage for application-based rendering:
  #/    bool HSWDisplayCurrentlyDisplayed = false; // global or class member variable
  #/    ovrHSWDisplayState hswDisplayState;
  #/    ovrhmd_GetHSWDisplayState(Hmd, &hswDisplayState);
  #/
  #/    if (hswDisplayState.Displayed && !HSWDisplayCurrentlyDisplayed) {
  #/        <insert model into the scene that stays in front of the user>
  #/        HSWDisplayCurrentlyDisplayed = true;
  #/    }
  ovrHmd_GetHSWDisplayState(ovrHmd, hmd, ovrHSWDisplayState * hasWarningState)
  #/ Requests a dismissal of the HSWDisplay at the earliest possible time, which may be seconds
  #/ into the future due to display longevity requirements.
  #/ Returns true if the display is valid, in which case the request can always be honored.
  #/
  #/ Example usage :
  #/    void ProcessEvent(int key) {
  #/        if (key == escape)
  #/            ovrhmd_DismissHSWDisplay(hmd);
  #/    }
  ovrHmd_DismissHSWDisplay(ovrHmd, hmd)
  #/ Get boolean property. Returns first element if property is a boolean array.
  #/ Returns defaultValue if property doesn't exist.
  ovrHmd_GetBool(ovrHmd, hmd, `const`, char * propertyName, ovrBool, defaultVal)
  #/ Modify bool property; false if property doesn't exist or is readonly.
  ovrHmd_SetBool(ovrHmd, hmd, `const`, char * propertyName, ovrBool, value)
  #/ Get integer property. Returns first element if property is an integer array.
  #/ Returns defaultValue if property doesn't exist.
  ovrHmd_GetInt(ovrHmd, hmd, `const`, char * propertyName, int, defaultVal)
  #/ Modify integer property; false if property doesn't exist or is readonly.
  ovrHmd_SetInt(ovrHmd, hmd, `const`, char * propertyName, int, value)
  #/ Get float property. Returns first element if property is a float array.
  #/ Returns defaultValue if property doesn't exist.
  ovrHmd_GetFloat(ovrHmd, hmd, `const`, char * propertyName, float, defaultVal)
  #/ Modify float property; false if property doesn't exist or is readonly.
  ovrHmd_SetFloat(ovrHmd, hmd, `const`, char * propertyName, float, value)
  #/ Get float[] property. Returns the number of elements filled in, 0 if property doesn't exist.
  #/ Maximum of arraySize elements will be written.
  ovrHmd_GetFloatArray(ovrHmd, hmd, `const`, char * propertyName, 
                       float * values, unsigned, int, arraySize)
  #/ Modify float[] property; false if property doesn't exist or is readonly.
  ovrHmd_SetFloatArray(ovrHmd, hmd, `const`, char * propertyName, 
                       float * values, unsigned, int, arraySize)
  #/ Get string property. Returns first element if property is a string array.
  #/ Returns defaultValue if property doesn't exist.
  #/ String memory is guaranteed to exist until next call to GetString or GetStringArray, or HMD is destroyed.
  ovrHmd_GetString(ovrHmd, hmd, `const`, char * propertyName, `const`, 
                   char * defaultVal)
  #/ Set string property
  ovrHmd_SetString(ovrHmd, hmddesc, `const`, char * propertyName, `const`, 
                   char * value)
  # 
  # -----------------------------------------------------------------------------------
  # ***** Logging
  #/ Send a message string to the system tracing mechanism if enabled (currently Event Tracing for Windows)
  #/ Level is one of the ovrLogLevel constants.
  #/ returns the length of the message, or -1 if message is too large
  ovr_TraceMessage(int, level, `const`, char * message)
  # DEPRECATED: These functions are being phased out in favor of a more comprehensive logging system.
  # These functions will return false and do nothing.
  ovrHmd_StartPerfLog(ovrHmd, hmd, `const`, char * fileName, `const`, 
                      char * userData1)
  ovrHmd_StopPerfLog(ovrHmd, hmd)
  # 
  # -----------------------------------------------------------------------------------
  # ***** Backward compatibility #includes
  #
  # This is at the bottom of this file because the following is dependent on the 
  # declarations above. 
  ##ifndef C2NIM