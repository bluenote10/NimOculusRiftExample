
import opengl
import wrapgl

type
  FramebufferTexture = object
    w, h: int
    id: GLuint

proc initFramebufferTexture*(w: int, h: int): FramebufferTexture =

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

  # gen & bind renderbuffer (for depth)
  let depthBufferId = glGenRenderbuffers()
  glBindRenderbuffer(GL_RENDERBUFFER, depthBufferId)
  glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT24, w.GLsizei, h.GLsizei)

  # attach texture to FBO
  glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textureId, 0)
  glDrawBuffers(GL_COLOR_ATTACHMENT0)
  
  # attach renderbuffer to FBO
  glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthBufferId)

  FramebufferTexture(w: w, h: h, id: framebufferId)
  
proc activate*(fb: FramebufferTexture) =
  glViewport(0, 0, fb.w.Glsizei, fb.h.Glsizei)
  glBindFramebuffer(GL_FRAMEBUFFER, fb.id)

proc deactivate*(fb: FramebufferTexture) =
  glBindFramebuffer(GL_FRAMEBUFFER, 0)

