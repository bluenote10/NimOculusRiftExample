#!/bin/bash

#c2nim --skipcomments ~/Downloads/Rift/ovr_sdk_linux_0.5.0.1/LibOVR/Include/OVR_CAPI_0_5_0.h -o ovr.nim

c2nim lib/OVR_CAPI_0_5_0.h -o ovr.nim
