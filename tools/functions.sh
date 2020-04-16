#!/bin/bash

# Common OrangeFox build script functions

# OrangeFox logo function
NORMAL=$(tput sgr0)
REVERSE=$(tput smso)

logo() {
printf "${NORMAL}                                                                               ${REVERSE}\n"
printf "${NORMAL}                                          ${REVERSE}   ${NORMAL}                                  ${REVERSE}\n"
printf "${NORMAL}                                        ${REVERSE}     ${NORMAL}                                  ${REVERSE}\n"
printf "${NORMAL}                                        ${REVERSE}     ${NORMAL}                                  ${REVERSE}\n"
printf "${NORMAL}                                  ${REVERSE}   ${NORMAL}    ${REVERSE}      ${NORMAL}                                ${REVERSE}\n"
printf "${NORMAL}                                ${REVERSE}      ${NORMAL}    ${REVERSE}       ${NORMAL}                              ${REVERSE}\n"
printf "${NORMAL}                               ${REVERSE}         ${NORMAL}   ${REVERSE}       ${NORMAL}                             ${REVERSE}\n"
printf "${NORMAL}                               ${REVERSE}    ${NORMAL}          ${REVERSE}     ${NORMAL}                             ${REVERSE}\n"
printf "${NORMAL}                               ${REVERSE}          ${NORMAL}    ${REVERSE}   ${NORMAL}                               ${REVERSE}\n"
printf "${NORMAL}                                ${REVERSE}               ${NORMAL}                                ${REVERSE}\n"
printf "${NORMAL}                                 ${REVERSE}               ${NORMAL}                               ${REVERSE}\n"
printf "${NORMAL}                                 ${REVERSE}  ${NORMAL}  ${REVERSE}  ${NORMAL}    ${REVERSE} ${NORMAL} ${REVERSE}    ${NORMAL}                              ${REVERSE}\n"
printf "${NORMAL}                                 ${REVERSE}  ${NORMAL}  ${REVERSE}  ${NORMAL}    ${REVERSE}  ${NORMAL}  ${REVERSE}  ${NORMAL}                              ${REVERSE}\n"
printf "${NORMAL}                                 ${REVERSE}  ${NORMAL}  ${REVERSE}  ${NORMAL}     ${REVERSE} ${NORMAL}   ${REVERSE}  ${NORMAL}                             ${REVERSE}\n"
printf "${NORMAL}                                                                               \n"
printf "                           OrangeFox Recovery Project                          \n\n"
printf "                           Build script by SebaUbuntu                          \n"
printf "                                      $SCRIPT_VERSION                                      \n\n"
}

# Import ofconfig
import_ofconfig () {
	IFS="
"
	if [ -f configs/"$1"_ofconfig ]; then
		for i in $(cat configs/"$1"_ofconfig); do
			if [ "$(printf '%s' "$i" | cut -c1)" != "#" ]; then
				export $i
			fi
		done
		IFS=" "
	else
		echo "Device-specific config not found!"
		IFS=" "
	fi
}
