#!/bin/bash

PREFIX_DIR="/root/prefix32"
WWW_DIR="${PREFIX_DIR}/drive_c/Program Files/Blue Iris 5/www"
LOGIN_HTM="${WWW_DIR}/login.htm"
UI3_VERSION="196"
UI3_ZIP="UI3-${UI3_VERSION}.zip"
UI3_URL="https://github.com/bp2008/ui3/releases/download/${UI3_VERSION}/${UI3_ZIP}"

while :
do
    sleep 10
    if [ ! -e "$LOGIN_HTM" ] ; then
        echo "BlueIris UI3 web frontend not found at $LOGIN_HTM. Installing ..."
        # I don't download the zip because I include in the image from data/www
        # if [ ! -e "$UI3_ZIP" ] ; then
        #     wget $UI3_URL
        # fi
        # unzip "$UI3_ZIP" -d "$WWW_DIR"
        # rm $UI3_ZIP
        rm -r "${WWW_DIR}"
        cp -R /root/www "${WWW_DIR}"
    # else
    #     echo "BlueIris UI3 web frontend seems to be setup properly."
    fi
done
