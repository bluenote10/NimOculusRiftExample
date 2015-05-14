
import opengl
import wrapgl
import utils

type
  FramebufferTexture* = object
    w*, h*: int
    id*: GLuint

proc checkFramebuffer(fail = true) =
  let status = glCheckFramebufferStatus(GL_FRAMEBUFFER)
  let errorMsg = case status:
    of GL_FRAMEBUFFER_COMPLETE: none(string)
    of GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT: some("GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT")
    of GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER: some("GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER")
    of GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT: some("GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT")
    of GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE: some("GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE")
    of GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER: some("GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER")
    of GL_FRAMEBUFFER_UNSUPPORTED: some("GL_FRAMEBUFFER_UNSUPPORTED")
    of GL_FRAMEBUFFER_UNDEFINED: some("GL_FRAMEBUFFER_UNDEFINED")
    else: some($status)
    
  #if msg ?= errorMsg:
  for msg in errorMsg:
    echo "Framebuffer status error: ", msg

  if fail and errorMsg.isSome:
    quit "Framebuffer check failed."


proc initFramebufferTexture*(w: int, h: int): FramebufferTexture =

  glCheckError()
  # gen & bind framebuffer
  let framebufferId = glGenFrameBuffers()
  glBindFramebuffer(GL_FRAMEBUFFER, framebufferId)

  # gen & bind texture (for colors)
  let textureId = glGenTextures()
  glBindTexture(GL_TEXTURE_2D, textureId)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR) # GL_NEAREST, GL_LINEAR, GL_LINEAR_MIPMAP_LINEAR
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
  # Allocate space for the texture
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, nil)
  glCheckError()

  # gen & bind renderbuffer (for depth)
  let depthBufferId = glGenRenderbuffers()
  glBindRenderbuffer(GL_RENDERBUFFER, depthBufferId)
  glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT24, w.GLsizei, h.GLsizei)
  glCheckError()

  # attach texture to FBO
  glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textureId, 0)
  glDrawBuffers(GL_COLOR_ATTACHMENT0)
  glCheckError()
  
  # attach renderbuffer to FBO
  glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthBufferId)
  glCheckError()

  checkFramebuffer()

  # unbind
  glBindFramebuffer(GL_FRAMEBUFFER, 0)
  glCheckError()
  
  FramebufferTexture(w: w, h: h, id: framebufferId)
  
proc activate*(fb: FramebufferTexture) =
  glViewport(0, 0, fb.w.Glsizei, fb.h.Glsizei)
  glBindFramebuffer(GL_FRAMEBUFFER, fb.id)

proc deactivate*(fb: FramebufferTexture) =
  glBindFramebuffer(GL_FRAMEBUFFER, 0)

