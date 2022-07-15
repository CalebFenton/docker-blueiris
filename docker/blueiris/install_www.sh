#!/bin/bash

BLUEIRIS_DIR="${WINEPREFIX}/drive_c/Program Files/Blue Iris 5"
WWW_DIR="${BLUEIRIS_DIR}/www"
LOGIN_HTM="${WWW_DIR}/login.htm"
UI3_VERSION="219"
# UI3_ZIP="UI3-${UI3_VERSION}.zip"
# UI3_URL="https://github.com/bp2008/ui3/releases/download/${UI3_VERSION}/${UI3_ZIP}"

while :
do
    sleep 10
    if [ ! -e "$BLUEIRIS_DIR" ] ; then
        echo "[*] Blue Iris not installed. Will ensure UI3 installed shortly."
        sleep 120
    else
        if [ ! -e "$LOGIN_HTM" ] ; then
            echo "[*] Blu Iris UI3 web frontend not found at ${LOGIN_HTM}; installing ..."
            # I don't download the zip because I include in the image from data/www
            # if [ ! -e "$UI3_ZIP" ] ; then
            #     wget $UI3_URL
            # fi
            # unzip "$UI3_ZIP" -d "$WWW_DIR"
            # rm $UI3_ZIP
            rm -fr "${WWW_DIR}" && \
                cp -R /opt/blueiris/www "${WWW_DIR}" && \
                # ln -s "${WWW_DIR}/vnc.html" "${WWW_DIR}/index.html" && \
                chown -R blueiris:blueiris "${WWW_DIR}"
            if [ $? -eq 0 ]; then
                echo "[*] Finished installing UI3 :)"
            else
                echo "[*] Failed to install UI3"
            fi
        # else
        #     echo "BlueIris UI3 web frontend seems to be setup properly."
        fi
    fi
done
