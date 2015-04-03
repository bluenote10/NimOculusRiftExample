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

# @file OVR_CAPI_0_5_0.h
# Exposes all general Rift functionality.

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

type 
  ovrBool* = char
const 
  ovrFalse* = 0
  ovrTrue* = 1
  
#-----------------------------------------------------------------------------------
# ***** Simple Math Structures
# A 2D vector with integer components.
type
  Vector2i* = object 
    x*: cint
    y*: cint

# A 2D size with integer components.
type 
  Sizei* = object 
    w*: cint
    h*: cint

# A 2D rectangle with a position and size.
# All components are integers.
type 
  Recti* = object 
    Pos*: ovrVector2i
    Size*: ovrSizei

# A quaternion rotation.
type 
  Quatf* = object 
    x*: cfloat
    y*: cfloat
    z*: cfloat
    w*: cfloat

# A 2D vector with float components.
type 
  Vector2f* = object 
    x*: cfloat
    y*: cfloat

# A 3D vector with float components.
type 
  Vector3f* = object 
    x*: cfloat
    y*: cfloat
    z*: cfloat

# A 4x4 matrix with float elements.
type 
  Matrix4f* = object 
    M*: array[4, array[4, cfloat]]

# Position and orientation together.
type 
  Posef* = object 
    Orientation*: Quatf
    Position*: Vector3f

# A full pose (rigid body) configuration with first and second derivatives.
type 
  PoseStatef* = object 
    ThePose*: Posef # The body's position and orientation.
    AngularVelocity*: Vector3f # The body's angular velocity in radians per second.
    LinearVelocity*: Vector3f # The body's velocity in meters per second.
    AngularAcceleration*: Vector3f # The body's angular acceleration in radians per second per second.
    LinearAcceleration*: Vector3f # The body's acceleration in meters per second per second.
    Pad*: cfloat # Unused struct padding.
    TimeInSeconds*: cdouble # Absolute time of this state sample.

# Field Of View (FOV) in tangent of the angle units.
# As an example, for a standard 90 degree vertical FOV, we would
# have: { UpTan = tan(90 degrees / 2), DownTan = tan(90 degrees / 2) }.
type 
  FovPort*  = object 
    UpTan* : cfloat # The tangent of the angle between the viewing vector and the top edge of the field of view.
    DownTan* : cfloat # The tangent of the angle between the viewing vector and the bottom edge of the field of view.
    LeftTan* : cfloat # The tangent of the angle between the viewing vector and the left edge of the field of view.
    RightTan* : cfloat # The tangent of the angle between the viewing vector and the right edge of the field of view.

    
#-----------------------------------------------------------------------------------
# ***** HMD Types
# Enumerates all HMD types that we support.
type 
  HmdType* {.size: sizeof(cint).} = enum 
    Hmd_None = 0,
    Hmd_DK1 = 3,
    Hmd_DKHD = 4,
    Hmd_DK2 = 6, 
    Hmd_BlackStar = 7,
    Hmd_CB = 8,
    Hmd_Other = 9, 
    Hmd_EnumSize = 0x7FFFFFFF

# HMD capability bits reported by device.
type
  HmdCaps* {.size: sizeof(cint).} = enum
    # Read-only flags
    HmdCap_Present           = 0x00000001, # (read only) The HMD is plugged in and detected by the system.
    HmdCap_Available         = 0x00000002, # (read only) The HMD and its sensor are available for ownership use.
                                           #             i.e. it is not already owned by another application.
    HmdCap_Captured          = 0x00000004, # (read only) Set to 'true' if we captured ownership of this HMD.
    HmdCap_ExtendDesktop     = 0x00000008, # (read only) Means the display driver works via acting as an addition display monitor.
    HmdCap_DebugDevice       = 0x00000010, # (read only) Means HMD device is a virtual debug device.
    # Modifiable flags (through ovrHmd_SetEnabledCaps).
    HmdCap_DisplayOff        = 0x00000040, # Turns off HMD screen and output (only if 'ExtendDesktop' is off).
    HmdCap_LowPersistence    = 0x00000080, # HMD supports low persistence mode.
    HmdCap_DynamicPrediction = 0x00000200, # Adjust prediction dynamically based on internally measured latency.
    HmdCap_NoVSync           = 0x00001000, # Support rendering without VSync for debugging.
    HmdCap_NoMirrorToWindow  = 0x00002000, # Disables mirroring of HMD output to the window. This may improve 
                                           # rendering performance slightly (only if 'ExtendDesktop' is off).
    HmdCap_EnumSize          = 0x7FFFFFFF

# Tracking capability bits reported by the device.
# Used with ovrHmd_ConfigureTracking.
type 
  TrackingCaps* {.size: sizeof(cint).} = enum 
    TrackingCap_Orientation      = 0x00000010, # Supports orientation tracking (IMU).
    TrackingCap_MagYawCorrection = 0x00000020, # Supports yaw drift correction via a magnetometer or other means.
    TrackingCap_Position         = 0x00000040, # Supports positional tracking.
    TrackingCap_Idle             = 0x00000100, # Overrides the other flags. Indicates that the application
                                               # doesn't care about tracking settings. This is the internal
                                               # default before ovrHmd_ConfigureTracking is called.
    TrackingCap_EnumSize         = 0x7FFFFFFF

# Distortion capability bits reported by device.
# Used with ovrHmd_ConfigureRendering and ovrHmd_CreateDistortionMesh.
type                        
  DistortionCaps* {.size: sizeof(cint).} = enum
    # 0x01 unused - Previously ovrDistortionCap_Chromatic now enabled permanently.
    DistortionCap_TimeWarp           = 0x00000002, # Supports timewarp.
    # 0x04 unused
    DistortionCap_Vignette           = 0x00000008, # Supports vignetting around the edges of the view.
    DistortionCap_NoRestore          = 0x00000010, # Do not save and restore the graphics and compute state when rendering distortion.
    DistortionCap_FlipInput          = 0x00000020, # Flip the vertical texture coordinate of input images.
    DistortionCap_SRGB               = 0x00000040, # Assume input images are in sRGB gamma-corrected color space.
    DistortionCap_Overdrive          = 0x00000080, # Overdrive brightness transitions to reduce artifacts on DK2+ displays
    DistortionCap_HqDistortion       = 0x00000100, # High-quality sampling of distortion buffer for anti-aliasing
    DistortionCap_LinuxDevFullscreen = 0x00000200, # Indicates window is fullscreen on a device when set. The SDK will automatically apply distortion mesh rotation if needed.
    DistortionCap_ComputeShader      = 0x00000400, # Using compute shader (DX11+ only)
   #DistortionCap_NoTimewarpJit      = 0x800         RETIRED - do not reuse this bit without major versioning changes.
    DistortionCap_TimewarpJitDelay   = 0x00001000, # Enables a spin-wait that tries to push time-warp to be as close to V-sync as possible. WARNING - this may backfire and cause framerate loss - use with caution.
    DistortionCap_ProfileNoSpinWaits = 0x00010000, # Use when profiling with timewarp to remove false positives
    DistortionCap_EnumSize = 0x7FFFFFFF

# Specifies which eye is being used for rendering.
# This type explicitly does not include a third "NoStereo" option, as such is
# not required for an HMD-centered API.
type 
  EyeType* {.size: sizeof(cint).} = enum 
    Eye_Left = 0,
    Eye_Right = 1,
    Eye_Count = 2, 
    Eye_EnumSize = 0x7FFFFFFF

# This is a complete descriptor of the HMD.
type 
  HmdDesc*  = object 
    Handle* : ptr HmdStruct                     # Internal handle of this HMD.
    #/ This HMD's type.
    Type* : HmdType                             # Name string describing the product: "Oculus Rift DK1", etc.
    ProductName* : cstring                      # String describing the manufacturer. Usually "Oculus".
    Manufacturer* : cstring                     # HID Vendor ID of the device.
    VendorId* : cshort                          # HID Product ID of the device.
    ProductId* : cshort                         # Sensor (and display) serial number.
    SerialNumber* : array[24, char]             # Sensor firmware major version number.
    FirmwareMajor* : cshort                     # Sensor firmware minor version number.
    FirmwareMinor* : cshort                     # External tracking camera frustum dimensions (if present).
    CameraFrustumHFovInRadians* : cfloat        # Horizontal field-of-view
    CameraFrustumVFovInRadians* : cfloat        # Vertical field-of-view
    CameraFrustumNearZInMeters* : cfloat        # Near clip distance
    CameraFrustumFarZInMeters* : cfloat         # Far clip distance
    HmdCaps* : cuint                            # Capability bits described by ovrHmdCaps.
    TrackingCaps* : cuint                       # Capability bits described by ovrTrackingCaps.
    DistortionCaps* : cuint                     # Capability bits described by ovrDistortionCaps.
    DefaultEyeFov* : array[Eye_Count, FovPort]  # The recommended optical FOV for the HMD.
    MaxEyeFov* : array[Eye_Count, FovPort]      # The maximum optical FOV for the HMD.
    EyeRenderOrder* : array[Eye_Count, EyeType] # Preferred eye rendering order for best performance.
                                                # Can help reduce latency on sideways-scanned screens.
    Resolution* : Sizei                         # Resolution of the full HMD screen (both eyes) in pixels.
    WindowsPos* : Vector2i                      # Location of the application window on the desktop (or 0,0).
    DisplayDeviceName* : cstring
    DisplayId* : cint

# Simple type ovrHmd is used in ovrHmd_* calls.
type 
  Hmd* = ptr HmdDesc

# Bit flags describing the current status of sensor tracking.
# The values must be the same as in enum StatusBits
type 
  StatusBits* {.size: sizeof(cint).} = enum 
    Status_OrientationTracked = 0x00000001, # Orientation is currently tracked (connected and in use).
    Status_PositionTracked    = 0x00000002, # Position is currently tracked (false if out of range).
    Status_CameraPoseTracked  = 0x00000004, # Camera pose is currently tracked.
    Status_PositionConnected  = 0x00000020, # Position tracking hardware is connected.
    Status_HmdConnected       = 0x00000080, # HMD Display is available and connected.
    Status_EnumSize           = 0x7FFFFFFF

# Specifies a reading we can query from the sensor.
type 
  SensorData* = object 
    Accelerometer* : Vector3f # Acceleration reading in m/s^2.
    Gyro* : Vector3f          # Rotation rate in rad/s.
    Magnetometer* : Vector3f  # Magnetic field in Gauss.
    Temperature* : cfloat     # Temperature of the sensor in degrees Celsius.
    TimeInSeconds* : cfloat   # Time when the reported IMU reading took place, in seconds.

# Tracking state at a given absolute time (describes predicted HMD pose etc).
# Returned by ovrHmd_GetTrackingState.
type 
  TrackingState* = object 
    HeadPose* : PoseStatef
    CameraPose* : Posef 
    LeveledCameraPose* : Posef
    RawSensorData* : SensorData
    StatusFlags* : cuint
    LastCameraFrameCounter* : uint32_t
    Pad* : uint32_t

# Frame timing data reported by ovrHmd_BeginFrameTiming() or ovrHmd_BeginFrame().
type 
  FrameTiming* = object 
    DeltaSeconds* : cfloat
    Pad* : cfloat
    ThisFrameSeconds* : cdouble
    TimewarpPointSeconds* : cdouble
    NextFrameSeconds* : cdouble
    ScanoutMidpointSeconds* : cdouble
    EyeScanoutSeconds* : array[2, cdouble]

# Rendering information for each eye. Computed by either ovrHmd_ConfigureRendering()
# or ovrHmd_GetRenderDesc() based on the specified FOV. Note that the rendering viewport
# is not included here as it can be specified separately and modified per frame through:
#    (a) ovrHmd_GetRenderScaleAndOffset in the case of client rendered distortion,
# or (b) passing different values via ovrTexture in the case of SDK rendered distortion.
type 
  EyeRenderDesc* = object 
    Eye* : EyeType                        # The eye index this instance corresponds to.
    Fov* : FovPort                        # The field of view.
    DistortedViewport* : Recti            # Distortion viewport.
    PixelsPerTanAngleAtCenter* : Vector2f # How many display pixels will fit in tan(angle) = 1.
    HmdToEyeViewOffset* : Vector3f        # Translation to be applied to view matrix for each eye offset.

#/ Rendering information for positional TimeWarp.
#/ Contains the data necessary to properly calculate position info for timewarp matrices
#/ and also interpret depth info provided via the depth buffer to the timewarp shader
type 
  PositionTimewarpDesc* {.importc: "ovrPositionTimewarpDesc", 
                             header: "OVR_CAPI_0_5_0_modified.h".} = object 
    HmdToEyeViewOffset* : array[2, 
        Vector3f]        #/ The same offset value pair provided in ovrEyeRenderDesc.
    #/ The near clip distance used in the projection matrix.
    NearClip* : cfloat #/ The far clip distance used in the projection matrix
                                              #/ utilized when rendering the eye depth textures provided in ovrHmd_EndFrame
    FarClip* : cfloat

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
  RenderAPIType* {.size: sizeof(cint).} = enum 
    RenderAPI_None, RenderAPI_OpenGL, RenderAPI_Android_GLES, # May include extra native window 
                                                                       # pointers, etc.
    RenderAPI_D3D9,      # Deprecated: Not supported for SDK rendering
    RenderAPI_D3D10,     # Deprecated: Not supported for SDK rendering
    RenderAPI_D3D11, RenderAPI_Count, RenderAPI_EnumSize = 0x7FFFFFFF
#/ Platform-independent part of rendering API-configuration data.
#/ It is a part of ovrRenderAPIConfig, passed to ovrHmd_Configure.
type 
  RenderAPIConfigHeader* {.importc: "ovrRenderAPIConfigHeader", 
                              header: "OVR_CAPI_0_5_0_modified.h".} = object 
    API* : RenderAPIType #/< The graphics API in use.
    BackBufferSize* : Sizei #/< Previously named RTSize.
    Multisample* : cint #/< The number of samples per pixel.

#/ Contains platform-specific information for rendering.
type 
  RenderAPIConfig* {.importc: "ovrRenderAPIConfig", 
                        header: "OVR_CAPI_0_5_0_modified.h".} = object 
    Header* : RenderAPIConfigHeader #/< Platform-independent rendering information.
    PlatformData* : array[8, uintptr_t] #/< Platform-specific rendering information.

#/ Platform-independent part of the eye texture descriptor.
#/ It is a part of ovrTexture, passed to ovrHmd_EndFrame.
#/ If RenderViewport is all zeros then the full texture will be used.
type 
  TextureHeader* {.importc: "ovrTextureHeader", 
                      header: "OVR_CAPI_0_5_0_modified.h".} = object 
    API* : RenderAPIType #/< The graphics API in use.
    TextureSize* : Sizei #/< The size of the texture.
    RenderViewport* : Recti #/< Pixel viewport in texture that holds eye image.

#/ Contains platform-specific information about a texture.
#/ Specialized for different rendering APIs in:
#/     ovrGLTexture, ovrD3D11Texture
type 
  Texture*  = object 
    Header* : TextureHeader #/< Platform-independent data about the texture.
    PlatformData* : array[8, uintptr_t] #/< Specialized in ovrGLTextureData, ovrD3D11TextureData etc.

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
_InitializeRenderingShimVersion(int, requestedMinorVersion)
_InitializeRenderingShim()
#/ Library init/shutdown, must be called around all other OVR code.
#/ No other functions calls besides ovr_InitializeRenderingShim are allowed before
#/ ovr_Initialize succeeds or after ovr_Shutdown.
#/ Initializes all Oculus functionality.
#/ A second call to ovr_Initialize after successful second call returns ovrTrue.
#/ Flags for Initialize()
type # When a debug library is requested, a slower debugging version of the library will
     # be run which can be used to help solve problems in the library and debug game code.
  InitFlags* {.size: sizeof(cint).} = enum 
    Init_Debug = 0x00000001, # When ServerOptional is set, the ovr_Initialize() call not will block waiting for
                                # the server to respond.  If the server is not reachable it may still succeed.
    Init_ServerOptional = 0x00000002, # When a version is requested, LibOVR runtime will respect the RequestedMinorVersion
                                         # field and will verify that the RequestedMinorVersion is supported.
    Init_RequestVersion = 0x00000004, # Forces debug features of LibOVR off explicitly, even if it is built in debug mode.
    Init_ForceNoDebug = 0x00000008
#/ Logging levels
type 
  LogLevel* {.size: sizeof(cint).} = enum 
    LogLevel_Debug = 0, LogLevel_Info = 1, LogLevel_Error = 2
#/ Signature for the logging callback.
#/ Level is one of the ovrLogLevel constants.
type 
  LogCallback* = proc (level: cint; message: cstring) {.cdecl.}
#/ Parameters for the ovr_Initialize() call.
type 
  InitParams* {.importc: "ovrInitParams", 
                   header: "OVR_CAPI_0_5_0_modified.h".} = object 
    Flags* : uint32_t #/ Flags from ovrInitFlags to override default behavior.
                                          #/ Pass 0 for the defaults.
    #/< Combination of ovrInitFlags or 0
    #/ Request a specific minimum minor version of the LibOVR runtime.
    #/ Flags must include ovrInit_RequestVersion or this will be ignored.
    RequestedMinorVersion* : uint32_t #/ Log callback function, which may be called at any time asynchronously from
                                                                          #/ multiple threads until ovr_Shutdown() completes.
                                                                          #/ Pass 0 for no log callback.
    LogCallback* : LogCallback #/< Function pointer or 0
                                                            #/ Number of milliseconds to wait for a connection to the server.
                                                            #/ Pass 0 for the default timeout.
    ConnectionTimeoutMS* : uint32_t #/< Timeout in Milliseconds or 0

#/ Initialize with extra parameters.
#/ Pass 0 to initialize with default parameters, suitable for released games.
#/ LibOVRRT shared library search order:
#/      1) Current working directory (often the same as the application directory).
#/      2) Module directory (usually the same as the application directory, but not if the module is a separate shared library).
#/      3) Application directory
#/      4) Development directory (only if OVR_ENABLE_DEVELOPER_SEARCH is enabled, which is off by default).
#/      5) Standard OS shared library search location(s) (OS-specific).
_Initialize(InitParams, `const` * params)
#/ Shuts down all Oculus functionality.
_Shutdown()
#/ Returns version string representing libOVR version. Static, so
#/ string remains valid for app lifespan
_GetVersionString()
#/ Detects or re-detects HMDs and reports the total number detected.
#/ Users can get information about each HMD by calling ovrHmd_Create with an index.
#/ Returns -1 when the service is unreachable.
Hmd_Detect()
#/ Creates a handle to an HMD which doubles as a description structure.
#/ Index can [0 .. ovrHmd_Detect()-1]. Index mappings can cange after each ovrHmd_Detect call.
#/ If not null, then the returned handle must be freed with ovrHmd_Destroy.
Hmd_Create(int, index)
Hmd_Destroy(Hmd, hmd)
#/ Creates a 'fake' HMD used for debugging only. This is not tied to specific hardware,
#/ but may be used to debug some of the related rendering.
Hmd_CreateDebug(HmdType, `type`)
#/ Returns last error for HMD state. Returns null for no error.
#/ String is valid until next call or GetLastError or HMD is destroyed.
#/ Pass null hmd to get global errors (during create etc).
Hmd_GetLastError(Hmd, hmd)
#/ Platform specific function to specify the application window whose output will be 
#/ displayed on the HMD. Only used if the ovrHmdCap_ExtendDesktop flag is false.
#/   Windows: SwapChain associated with this window will be displayed on the HMD.
#/            Specify 'destMirrorRect' in window coordinates to indicate an area
#/            of the render target output that will be mirrored from 'sourceRenderTargetRect'.
#/            Null pointers mean "full size".
#/ @note Source and dest mirror rects are not yet implemented.
Hmd_AttachToWindow(Hmd, hmd, void * window, `const`, 
                      Recti * destMirrorRect, `const`, 
                      Recti * sourceRenderTargetRect)
#/ Returns capability bits that are enabled at this time as described by ovrHmdCaps.
#/ Note that this value is different font ovrHmdDesc::HmdCaps, which describes what
#/ capabilities are available for that HMD.
Hmd_GetEnabledCaps(Hmd, hmd)
#/ Modifies capability bits described by ovrHmdCaps that can be modified,
#/ such as ovrHmdCap_LowPersistance.
Hmd_SetEnabledCaps(Hmd, hmd, unsigned, int, hmdCaps)
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
Hmd_ConfigureTracking(Hmd, hmd, unsigned, int, supportedTrackingCaps, 
                         unsigned, int, requiredTrackingCaps)
#/ Re-centers the sensor orientation.
#/ Normally this will recenter the (x,y,z) translational components and the yaw
#/ component of orientation.
Hmd_RecenterPose(Hmd, hmd)
#/ Returns tracking state reading based on the specified absolute system time.
#/ Pass an absTime value of 0.0 to request the most recent sensor reading. In this case
#/ both PredictedPose and SamplePose will have the same value.
#/ ovrHmd_GetEyePoses relies on a valid ovrTrackingState.
#/ This may also be used for more refined timing of FrontBuffer rendering logic, etc.
Hmd_GetTrackingState(Hmd, hmd, double, absTime)
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
Hmd_GetFovTextureSize(Hmd, hmd, EyeType, eye, FovPort, fov, float, 
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
Hmd_ConfigureRendering(Hmd, hmd, `const`, 
                          RenderAPIConfig * apiConfig, unsigned, int, 
                          distortionCaps, `const`, FovPort, eyeFovIn[2], 
                          EyeRenderDesc, eyeRenderDescOut[2])
#/ Begins a frame, returning timing information.
#/ This should be called at the beginning of the game rendering loop (on the render thread).
#/ Pass 0 for the frame index if not using ovrHmd_GetFrameTiming.
Hmd_BeginFrame(Hmd, hmd, unsigned, int, frameIndex)
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
Hmd_EndFrame(Hmd, hmd, `const`, Posef, renderPose[2], `const`, 
                Texture, eyeTexture[2])
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
Hmd_GetEyePoses(Hmd, hmd, unsigned, int, frameIndex, `const`, 
                   Vector3f, hmdToEyeViewOffset[2], Posef, 
                   outEyePoses[2], TrackingState * outHmdTrackingState)
#/ Function was previously called ovrHmd_GetEyePose
#/ Returns the predicted head pose to use when rendering the specified eye.
#/ - Important: Caller must apply HmdToEyeViewOffset before using ovrPosef for rendering
#/ - Must be called between ovrHmd_BeginFrameTiming and ovrHmd_EndFrameTiming.
#/ - If returned pose is used for rendering the eye, it should be passed to ovrHmd_EndFrame.
#/ - Parameter 'eye' is used internally for prediction timing only
Hmd_GetHmdPosePerEye(Hmd, hmd, EyeType, eye)
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
Hmd_GetRenderDesc(Hmd, hmd, EyeType, eyeType, FovPort, fov)
#/ Describes a vertex used by the distortion mesh. This is intended to be converted into
#/ the engine-specific format. Some fields may be unused based on the ovrDistortionCaps
#/ flags selected. TexG and TexB, for example, are not used if chromatic correction is
#/ not requested.
type 
  DistortionVertex* {.importc: "ovrDistortionVertex", 
                         header: "OVR_CAPI_0_5_0_modified.h".} = object 
    ScreenPosNDC* : Vector2f #/< [-1,+1],[-1,+1] over the entire framebuffer.
    TimeWarpFactor* : cfloat #/< Lerp factor between time-warp matrices. Can be encoded in Pos.z.
    VignetteFactor* : cfloat #/< Vignette fade factor. Can be encoded in Pos.w.
    TanEyeAnglesR* : Vector2f #/< The tangents of the horizontal and vertical eye angles for the red channel.
    TanEyeAnglesG* : Vector2f #/< The tangents of the horizontal and vertical eye angles for the green channel.
    TanEyeAnglesB* : Vector2f #/< The tangents of the horizontal and vertical eye angles for the blue channel.

#/ Describes a full set of distortion mesh data, filled in by ovrHmd_CreateDistortionMesh.
#/ Contents of this data structure, if not null, should be freed by ovrHmd_DestroyDistortionMesh.
type 
  DistortionMesh* {.importc: "ovrDistortionMesh", 
                       header: "OVR_CAPI_0_5_0_modified.h".} = object 
    pVertexData* : ptr DistortionVertex #/< The distortion vertices representing each point in the mesh.
    pIndexData* : ptr cushort #/< Indices for connecting the mesh vertices into polygons.
    VertexCount* : cuint #/< The number of vertices in the mesh.
    IndexCount* : cuint #/< The number of indices in the mesh.

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
Hmd_CreateDistortionMesh(Hmd, hmd, EyeType, eyeType, FovPort, fov, 
                            unsigned, int, distortionCaps, 
                            DistortionMesh * meshData)
Hmd_CreateDistortionMeshDebug(Hmd, hmddesc, EyeType, eyeType, 
                                 FovPort, fov, unsigned, int, 
                                 distortionCaps, DistortionMesh * meshData, 
                                 float, debugEyeReliefOverrideInMetres)
#/ Used to free the distortion mesh allocated by ovrHmd_GenerateDistortionMesh. meshData elements
#/ are set to null and zeroes after the call.
Hmd_DestroyDistortionMesh(DistortionMesh * meshData)
#/ Computes updated 'uvScaleOffsetOut' to be used with a distortion if render target size or
#/ viewport changes after the fact. This can be used to adjust render size every frame if desired.
Hmd_GetRenderScaleAndOffset(FovPort, fov, Sizei, textureSize, 
                               Recti, renderViewport, Vector2f, 
                               uvScaleOffsetOut[2])
#/ Thread-safe timing function for the main thread. Caller should increment frameIndex
#/ with every frame and pass the index where applicable to functions called on the
#/ rendering thread.
Hmd_GetFrameTiming(Hmd, hmd, unsigned, int, frameIndex)
#/ Called at the beginning of the frame on the rendering thread.
#/ Pass frameIndex == 0 if ovrHmd_GetFrameTiming isn't being used. Otherwise,
#/ pass the same frame index as was used for GetFrameTiming on the main thread.
Hmd_BeginFrameTiming(Hmd, hmd, unsigned, int, frameIndex)
#/ Marks the end of client distortion rendered frame, tracking the necessary timing information.
#/ This function must be called immediately after Present/SwapBuffers + GPU sync. GPU sync is
#/ important before this call to reduce latency and ensure proper timing.
Hmd_EndFrameTiming(Hmd, hmd)
#/ Initializes and resets frame time tracking. This is typically not necessary, but
#/ is helpful if game changes vsync state or video mode. vsync is assumed to be on if this
#/ isn't called. Resets internal frame index to the specified number.
Hmd_ResetFrameTiming(Hmd, hmd, unsigned, int, frameIndex)
#/ Computes timewarp matrices used by distortion mesh shader, these are used to adjust
#/ for head orientation change since the last call to ovrHmd_GetEyePoses
#/ when rendering this eye. The ovrDistortionVertex::TimeWarpFactor is used to blend between the
#/ matrices, usually representing two different sides of the screen.
#/ Set 'calcPosition' to true when using depth based positional timewarp
#/ Must be called on the same thread as ovrHmd_BeginFrameTiming.
Hmd_GetEyeTimewarpMatrices(Hmd, hmd, EyeType, eye, Posef, 
                              renderPose, Matrix4f, twmOut[2])
Hmd_GetEyeTimewarpMatricesDebug(Hmd, hmddesc, EyeType, eye, Posef, 
                                   renderPose, Quatf, playerTorsoMotion, 
                                   Matrix4f, twmOut[2], double, 
                                   debugTimingOffsetInSeconds)
#-------------------------------------------------------------------------------------
# ***** Stateless math setup functions
#/ Returns global, absolute high-resolution time in seconds. This is the same
#/ value as used in sensor messages.
_GetTimeInSeconds()
# 
# -----------------------------------------------------------------------------------
# ***** Latency Test interface
#/ Does latency test processing and returns 'TRUE' if specified rgb color should
#/ be used to clear the screen.
Hmd_ProcessLatencyTest(Hmd, hmd, unsigned, char, rgbColorOut[3])
#/ Returns non-null string once with latency test result, when it is available.
#/ Buffer is valid until next call.
Hmd_GetLatencyTestResult(Hmd, hmd)
#/ Returns the latency testing color in rgbColorOut to render when using a DK2
#/ Returns false if this feature is disabled or not-applicable (e.g. using a DK1)
Hmd_GetLatencyTest2DrawColor(Hmd, hmddesc, unsigned, char, 
                                rgbColorOut[3])
#-------------------------------------------------------------------------------------
# ***** Health and Safety Warning Display interface
#
#/ Used by ovrhmd_GetHSWDisplayState to report the current display state.
type 
  HSWDisplayState* {.importc: "ovrHSWDisplayState", 
                        header: "OVR_CAPI_0_5_0_modified.h".} = object 
    Displayed* : ovrBool #/ If true then the warning should be currently visible
                                                 #/ and the following variables have meaning. Else there is no
                                                 #/ warning being displayed for this application on the given HMD.
    #/< True if the Health&Safety Warning is currently displayed.
    Pad* : array[8 - sizeof((ovrBool)), char] #/< Unused struct padding.
    StartTime* : cdouble #/< Absolute time when the warning was first displayed. See ovr_GetTimeInSeconds().
    DismissibleTime* : cdouble #/< Earliest absolute time when the warning can be dismissed. May be a time in the past.

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
Hmd_GetHSWDisplayState(Hmd, hmd, HSWDisplayState * hasWarningState)
#/ Requests a dismissal of the HSWDisplay at the earliest possible time, which may be seconds
#/ into the future due to display longevity requirements.
#/ Returns true if the display is valid, in which case the request can always be honored.
#/
#/ Example usage :
#/    void ProcessEvent(int key) {
#/        if (key == escape)
#/            ovrhmd_DismissHSWDisplay(hmd);
#/    }
Hmd_DismissHSWDisplay(Hmd, hmd)
#/ Get boolean property. Returns first element if property is a boolean array.
#/ Returns defaultValue if property doesn't exist.
Hmd_GetBool(Hmd, hmd, `const`, char * propertyName, ovrBool, defaultVal)
#/ Modify bool property; false if property doesn't exist or is readonly.
Hmd_SetBool(Hmd, hmd, `const`, char * propertyName, ovrBool, value)
#/ Get integer property. Returns first element if property is an integer array.
#/ Returns defaultValue if property doesn't exist.
Hmd_GetInt(Hmd, hmd, `const`, char * propertyName, int, defaultVal)
#/ Modify integer property; false if property doesn't exist or is readonly.
Hmd_SetInt(Hmd, hmd, `const`, char * propertyName, int, value)
#/ Get float property. Returns first element if property is a float array.
#/ Returns defaultValue if property doesn't exist.
Hmd_GetFloat(Hmd, hmd, `const`, char * propertyName, float, defaultVal)
#/ Modify float property; false if property doesn't exist or is readonly.
Hmd_SetFloat(Hmd, hmd, `const`, char * propertyName, float, value)
#/ Get float[] property. Returns the number of elements filled in, 0 if property doesn't exist.
#/ Maximum of arraySize elements will be written.
Hmd_GetFloatArray(Hmd, hmd, `const`, char * propertyName, 
                     float * values, unsigned, int, arraySize)
#/ Modify float[] property; false if property doesn't exist or is readonly.
Hmd_SetFloatArray(Hmd, hmd, `const`, char * propertyName, 
                     float * values, unsigned, int, arraySize)
#/ Get string property. Returns first element if property is a string array.
#/ Returns defaultValue if property doesn't exist.
#/ String memory is guaranteed to exist until next call to GetString or GetStringArray, or HMD is destroyed.
Hmd_GetString(Hmd, hmd, `const`, char * propertyName, `const`, 
                 char * defaultVal)
#/ Set string property
Hmd_SetString(Hmd, hmddesc, `const`, char * propertyName, `const`, 
                 char * value)
# 
# -----------------------------------------------------------------------------------
# ***** Logging
#/ Send a message string to the system tracing mechanism if enabled (currently Event Tracing for Windows)
#/ Level is one of the ovrLogLevel constants.
#/ returns the length of the message, or -1 if message is too large
_TraceMessage(int, level, `const`, char * message)
# DEPRECATED: These functions are being phased out in favor of a more comprehensive logging system.
# These functions will return false and do nothing.
Hmd_StartPerfLog(Hmd, hmd, `const`, char * fileName, `const`, 
                    char * userData1)
Hmd_StopPerfLog(Hmd, hmd)
# 
# -----------------------------------------------------------------------------------
# ***** Backward compatibility #includes
#
# This is at the bottom of this file because the following is dependent on the 
# declarations above. 
##ifndef C2NIM