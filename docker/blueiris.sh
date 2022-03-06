#!/bin/bash

# https://github.com/jshridha/docker-blueiris/issues/54
export WINEDEBUG=-all
export WINEPREFIX="/root/prefix32"

WINPREFIX="/root/prefix32"
BLUEIRIS_EXE="${WINPREFIX}/drive_c/Program Files/Blue Iris 5/BlueIris.exe"
INSTALL_EXE="/root/blueiris.exe"

# WWW_DIR="${WINPREFIX}/drive_c/Program Files/Blue Iris 5/www"
# LOGIN_HTM="${WWW_DIR}/login.htm"
# UI3_VERSION="196"
# UI3_ZIP="UI3-${UI3_VERSION}.zip"
# UI3_URL="https://github.com/bp2008/ui3/releases/download/${UI3_VERSION}/${UI3_ZIP}"

if [ ! -d "$WINPREFIX/drive_c" ]; then
    mv /root/prefix32_original/* $WINPREFIX
fi

chown -R root:root $WINPREFIX

if [ ! -e "$BLUEIRIS_EXE" ] ; then
    echo "BlueIris not found at $BLUEIRIS_EXE. Installing ..."
    if [ ! -e "$INSTALL_EXE" ] ; then
        wget https://blueirissoftware.com/blueiris.exe
    fi
    echo "Running installer. You'll need to setup over VNC now."
    wine blueiris.exe
    rm blueiris.exe
else
    echo "BlueIris seems to be installed."
fi

echo "Starting BlueIris at ${BLUEIRIS_EXE}"
wine "$BLUEIRIS_EXE"
