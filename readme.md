## NimOculusRiftExample

This is a simple Oculus Rift example written in Nim, using my [bindings for libOVR](https://github.com/bluenote10/nim-ovr).
In order to run the example, you have to install the following dependencies in nimble:

    nimble install opengl
    nimble install nim-glfw
    nimble install nim-ovr

The example was only tested under Linux using libOVR 0.5.0.1, but it should be straightforward to run on other systems.
The example uses GLFW version 3
(for Ubuntu 14.04 and older, the official ``libglfw-dev`` is still version 2, but ``libglfw3-dev`` can be installed [from this ppa](https://launchpad.net/~keithw/+archive/ubuntu/glfw3).

The demo scene simply generates a random heap of LEGO-like bricks (official LEGO dimensions and colors but without knobs):

![screenshot](screenshot.png)

The graphics engine uses modern but simple OpenGL techniques, i.e., VAO + VBO + a Gaussian lighting shader.


