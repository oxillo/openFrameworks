#!/usr/bin/env bash

script_dir="$( dirname "$(readlink -f "$0")" )"

function usage {
    echo usage:
    echo ./install_dependencies.sh [--help] [--noconfirm]
    echo --help:
    echo display this message
    echo
    echo --noconfirm:
    echo install packages without user confirmation
}

#Analyse script arguments
while [[ $# > 0 ]] ; do
	arg=$1
	shift
	if [ "$arg" == "--noconfirm" ]; then
		confirm=--noconfirm
		continue
	fi
	if [ "$arg" == "--help" ]; then
		usage
		exit 1
	fi
	echo Invalid argument : $arg
	usage
	exit 1
done


arch=i686
if [ -z ${confirm+x} ]; then
	pacman -S $confirm --needed ca-certificates
	if [ -z ${APPVEYOR+x} ]; then
		pacman -S $confirm --needed wget rsync unzip make mingw-w64-$arch-gcc mingw-w64-$arch-ntldd-git
	fi
	pacman -S $confirm --needed mingw-w64-$arch-glew \
		mingw-w64-$arch-freeglut \
		mingw-w64-$arch-FreeImage \
		mingw-w64-$arch-opencv \
		mingw-w64-$arch-assimp \
		mingw-w64-$arch-boost \
		mingw-w64-$arch-cairo \
		mingw-w64-$arch-clang \
		mingw-w64-$arch-gdb \
		mingw-w64-$arch-zlib \
		mingw-w64-$arch-tools \
		mingw-w64-$arch-pkg-config \
		mingw-w64-$arch-poco \
		mingw-w64-$arch-glfw \
		mingw-w64-$arch-libusb \
		mingw-w64-$arch-harfbuzz \
		mingw-w64-$arch-poco \
		mingw-w64-$arch-curl \
		mingw-w64-$arch-libxml2
else
	pacman -S $confirm --needed mingw-w64-$arch-harfbuzz
	pacman -S $confirm --needed ca-certificates
	if [ -z ${APPVEYOR+x} ]; then
		pacman -S $confirm --needed wget
		pacman -S $confirm --needed rsync
		pacman -S $confirm --needed unzip
		pacman -S $confirm --needed make
		pacman -S $confirm --needed mingw-w64-$arch-gcc
		pacman -S $confirm --needed mingw-w64-$arch-ntldd-git
	fi
	pacman -S $confirm --needed mingw-w64-$arch-glew
	pacman -S $confirm --needed mingw-w64-$arch-freeglut
	pacman -S $confirm --needed mingw-w64-$arch-FreeImage
	pacman -S $confirm --needed mingw-w64-$arch-opencv
	pacman -S $confirm --needed mingw-w64-$arch-assimp
	pacman -S $confirm --needed mingw-w64-$arch-boost
	pacman -S $confirm --needed mingw-w64-$arch-cairo
	pacman -S $confirm --needed mingw-w64-$arch-clang
	pacman -S $confirm --needed mingw-w64-$arch-gdb
	pacman -S $confirm --needed mingw-w64-$arch-zlib
	pacman -S $confirm --needed mingw-w64-$arch-tools
	pacman -S $confirm --needed mingw-w64-$arch-pkg-config
	pacman -S $confirm --needed mingw-w64-$arch-poco
	pacman -S $confirm --needed mingw-w64-$arch-glfw
	pacman -S $confirm --needed mingw-w64-$arch-libusb
	pacman -S $confirm --needed mingw-w64-$arch-poco
	pacman -S $confirm --needed mingw-w64-$arch-curl
	pacman -S $confirm --needed mingw-w64-$arch-libxml2
fi


# this would install gstreamer which can be used in mingw too
#pacman -Sy mingw-w64-$arch-gst-libav mingw-w64-$arch-gst-plugins-bad mingw-w64-$arch-gst-plugins-base mingw-w64-$arch-gst-plugins-good mingw-w64-$arch-gst-plugins-ugly mingw-w64-$arch-gstreamer

exit_code=$?
if [ $exit_code != 0 ]; then
	echo "error installing packages, there could be an error with your internet connection"
	exit $exit_code
fi


# Update addon_config.mk files to use OpenCV 3 or 4 depending on what's installed
addons_dir="$(readlink -f "$script_dir/../../addons")"
$(pkg-config opencv4 --exists)
exit_code=$?
if [ $exit_code != 0 ]; then
	echo "Updating ofxOpenCV to use openCV3"
	sed -i -E 's/ADDON_PKG_CONFIG_LIBRARIES =(.*)opencv4(.*)$/ADDON_PKG_CONFIG_LIBRARIES =\1opencv\2/' "$addons_dir/ofxOpenCv/addon_config.mk"
else
	echo "Updating ofxOpenCV to use openCV4"
	sed -i -E 's/ADDON_PKG_CONFIG_LIBRARIES =(.*)opencv\s/ADDON_PKG_CONFIG_LIBRARIES =\1opencv4 /g' "$addons_dir/ofxOpenCv/addon_config.mk"
	sed -i -E 's/ADDON_PKG_CONFIG_LIBRARIES =(.*)opencv$/ADDON_PKG_CONFIG_LIBRARIES =\1opencv4/g' "$addons_dir/ofxOpenCv/addon_config.mk"
fi
