#!/bin/bash

# Common variables for OF building scripts
export_common_variables () {
# For building with mimimal TWRP
export ALLOW_MISSING_DEPENDENCIES=true
export TW_DEFAULT_LANGUAGE="en"
# This fix build bug when locale is not "C"
export LC_ALL="C"
# To use ccache to speed up building
export USE_CCACHE="1"
# Prevent issues like bootloop on encrypted devices
export OF_DONT_PATCH_ENCRYPTED_DEVICE="1"
# Try to decrypt data when a MIUI backup is restored
export OF_OTA_RES_DECRYPT="1"
# Include full bash shell
export FOX_USE_BASH_SHELL="1"
# Include nano editor
export FOX_USE_NANO_EDITOR="1"
# Modify this variable to your name
export OF_MAINTAINER="SebaUbuntu"
# Enable ccache
ccache -M 20G
}
