#!/bin/bash

# Common variables for OF building scripts
# For building with mimimal TWRP
export ALLOW_MISSING_DEPENDENCIES=true
export TW_DEFAULT_LANGUAGE="en"
# This fix build bug when locale is not "C"
export LC_ALL="C"
# To use ccache to speed up building
export USE_CCACHE="1"
# Modify this variable to your name
export OF_MAINTAINER="SebaUbuntu"
