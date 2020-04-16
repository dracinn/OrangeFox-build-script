#!/bin/bash
# OrangeFox building script by SebaUbuntu
# You can find a list of all variables at OF_ROOT_DIR/vendor/recovery/orangefox_build_vars.txt

SCRIPT_VERSION="v2.2"

# Import common functions
source ./tools/functions.sh
# Import Telegram Bot API wrapper
source ./tools/telegram.sh
# Import common variables
source ./tools/variables.sh

clear
logo
# AOSP enviroment setup
echo "AOSP environment setup, please wait..."
. build/envsetup.sh
clear

logo
# Ask user if a clean build is needed
printf "Do you want to post this on Telegram channel or group?\nFor info read README.md\nAnswer: "
read TG_POST

case $TG_POST in
	yes|y|true|1)
		TG_POST=Yes
		printf "\nTelegram posting of this release activated\n\n"
		get_telegram_keys
		sleep 1
		;;
	*)
		TG_POST=No
		printf "\nTelegram posting of this release not requested, skipping...\n\n"
		sleep 1
		;;
esac

clear

logo
# Ask user if a clean build is needed
printf "Do you want to do a clean build?\nAnswer: "
read CLEAN_BUILD_NEEDED

case $CLEAN_BUILD_NEEDED in
	yes|y|true|1)
		CLEAN_BUILD_NEEDED=Yes
		printf "\nDeleting out/ dir, please wait..."
		make clean
		sleep 2
		clear
		;;
	*)
		CLEAN_BUILD_NEEDED=No
		printf "\nClean build not required, skipping..."
		sleep 2
		clear
		;;
esac

logo
# what device are we building for?
printf "Insert the device codename you want to build for\nCodename: "
read TARGET_DEVICE
clear

logo
# Ask for release version
printf "Insert the version number of this release\nExample: R10.1\nVersion: "
read FOX_VERSION
export FOX_VERSION
clear

logo
# Ask for release type
printf "Insert the type of this release\nPossibilities: Stable - Beta - RC - Unofficial\nRelease type: "
read BUILD_TYPE
export BUILD_TYPE
clear

logo

# Import OrangeFox build variables
export_common_variables
import_ofconfig $TARGET_DEVICE

# TARGET_ARCH variable is needed by OrangeFox to determine which version of binary to include
if [ -z ${TARGET_ARCH+x} ]
	then
		echo "You didn't set TARGET_ARCH variable in config"
		exit
fi

# Define this value to fix graphical issues
if [ -z ${OF_SCREEN_H+x} ]
	then
		echo "You didn't set OF_SCREEN_H variable in config
This variable is needed to fix graphical issues on non-16:9 devices.
Even if you have a 16:9 device, set it anyway."
		exit
fi


# Lunch device
lunch omni_"$TARGET_DEVICE"-eng

# If lunch command fail, there is no need to continue building
if [ "$?" != "0" ]; then
	exit
fi

# Send message about started build
if [ $TG_POST = "Yes" ]; then
	send_message "Build started

OrangeFox $FOX_VERSION $FOX_BUILD_TYPE
Device: $TARGET_DEVICE
Architecture: $TARGET_ARCH
Clean build: $CLEAN_BUILD_NEEDED
Output:"
fi

# Start building
mka recoveryimage
build_result="$?"

# If build had success, send file to a Telegram channel, else say failed
if [ $TG_POST = "Yes" ]; then
	if [ "$build_result" = "0" ]; then
		
		edit_message "Build finished!

OrangeFox $FOX_VERSION $FOX_BUILD_TYPE
Device: $TARGET_DEVICE
Architecture: $TARGET_ARCH
Clean build: $CLEAN_BUILD_NEEDED
Output:"
		echo ""
		send_file "out/target/product/$TARGET_DEVICE/OrangeFox-$FOX_VERSION-$FOX_BUILD_TYPE-$TARGET_DEVICE.zip"
		echo ""
	else
		edit_message "Build failed!

OrangeFox $FOX_VERSION $FOX_BUILD_TYPE
Device: $TARGET_DEVICE
Architecture: $TARGET_ARCH
Clean build: $CLEAN_BUILD_NEEDED
Output:"
		echo ""
	fi
fi

