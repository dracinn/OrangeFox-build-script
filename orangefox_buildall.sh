#!/bin/bash

# Import common functions
source ./tools/functions.sh
# Import Telegram Bot API wrapper
source ./tools/telegram.sh
# Import common variables
source ./tools/variables.sh

OF_VERSION="R10.1"

# Clean
rm -rf out/
rm -rf .repo/local_manifests
rm -rf builds/
mkdir builds/
# Clone local manifests containing device trees and repo sync
git clone https://github.com/SebaUbuntu/local_manifests -b OrangeFox-9.0 .repo/local_manifests
repo sync --force-sync -j$(nproc --all)

# AOSP enviroment setup
echo "AOSP environment setup, please wait..."
. build/envsetup.sh

get_telegram_keys

devices=$(cat devices.txt)

generate_progress_list() {
	if [ -f building_status.txt ]; then
		rm building_status.txt
	fi
	for i in $devices; do
		echo "$i = ${!i}" >> building_status.txt
	done
}

update_message() {
	generate_progress_list
	edit_message "OrangeFox build started for all devices

$(cat building_status.txt)"
}

for device in $devices; do
	export $device="In queue"
	generate_progress_list
done

send_message "OrangeFox build started for all devices

$(cat building_status.txt)"

for TARGET_DEVICE in $devices; do
	# Retrieve last version with OF API
	CURRENT_VERSION=$(curl https://api-v1.orangefox.download/last_stable_release/${TARGET_DEVICE}/ | jq .version | cut -d "\"" -f 2)
	if [ "$CURRENT_VERSION" != "$OF_VERSION" ]; then
		CURRENT_DEVICE_VERSION=$(echo $CURRENT_VERSION | cut -d'_' -f 2)
	else
		CURRENT_DEVICE_VERSION=0
	fi
	NEW_VERSION=$(( CURRENT_DEVICE_VERSION + 1  ))
	export FOX_VERSION=${OF_VERSION}_${NEW_VERSION}
	export_common_variables
	for i in $(cat configs/${TARGET_DEVICE}_ofconfig); do
		if [ "$(printf '%s' "$i" | cut -c1)" != "#" ]; then
			export $i
		fi
	done
	export $TARGET_DEVICE="Lunching"
	update_message
	lunch omni_${TARGET_DEVICE}-eng
	LUNCH_RESULT="$?"
	if [ "$LUNCH_RESULT" != "0" ]; then
		export $TARGET_DEVICE="Failed during lunch"
	else
		export $TARGET_DEVICE="Building"
	fi
	update_message
	mka recoveryimage
	BUILD_RESULT="$?"
	if [ "$BUILD_RESULT" != "0" ]; then
		export $TARGET_DEVICE="Failed during building"
	else
		export $TARGET_DEVICE="Build completed"
		cp "out/target/product/$TARGET_DEVICE/OrangeFox-$FOX_VERSION-$FOX_BUILD_TYPE-$TARGET_DEVICE.zip" "builds/"
	fi
	update_message
done
