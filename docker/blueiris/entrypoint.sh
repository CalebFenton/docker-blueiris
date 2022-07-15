#!/bin/bash

export WINEDEBUG=${WINE_DEBUG_OPT}

PROGRAM_FILES="${WINEPREFIX}/drive_c/Program Files"
export BLUEIRIS_EXE="${PROGRAM_FILES}/Blue Iris 5/BlueIris.exe"
DOWNLOAD_DIR="/tmp"
INSTALL_EXE="${DOWNLOAD_DIR}/blueiris.exe"

if [ ! -f "${WINEPREFIX}/drive_c/windows/system32/kernel32.dll" ]; then
    echo "[*] Wine prefix missing. Installing from ${WINEPREFIX}.7z to ${WINEPREFIX}. This will take a while."
    7z x -y "${WINEPREFIX}.7z" -w/opt/wine -o/opt/wine
    echo "[*] Finished installing wine prefix."
fi

echo "[*] Setting ownership of ${WINEPREFIX}"
chown -R blueiris:blueiris "${WINEPREFIX}"

if [ ! -e "$BLUEIRIS_EXE" ]; then
    echo "[*] Blue Iris not found at $BLUEIRIS_EXE; installing."
    if [ ! -e "$INSTALL_EXE" ]; then
        cd "$DOWNLOAD_DIR"
        su blueiris -c 'curl -fsSL --remote-name https://blueirissoftware.com/blueiris.exe'
    fi
    echo "[*] Starting installer; finish over VNC."
    # TODO: if ARCH==64, use wine64!
    if [ "${WINEARCH}" = "win64" ]; then
        su blueiris -c 'wine64 blueiris.exe'
    else
        su blueiris -c 'wine blueiris.exe'
    fi
    rm blueiris.exe
    sleep 5
# else
#     echo "[*] Blue Iris is already installed."
fi

echo "[*] Starting Blue Iris at ${BLUEIRIS_EXE}"
if [ "${WINEARCH}" = "win64" ]; then
    su blueiris -c 'wine64 "${BLUEIRIS_EXE}"'
else
    su blueiris -c 'wine "${BLUEIRIS_EXE}"'
fi
