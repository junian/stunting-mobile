#!/bin/sh

fvm install
fvm flutter pub get

FILE="./android/key.properties"
if [ ! -f "$FILE" ]; then
    echo "$FILE does not exist. Creating a new file."
    echo "storePassword=<password-from-previous-step>" >> "$FILE"
    echo "keyPassword=<password-from-previous-step>" >> "$FILE"
    echo "keyAlias=upload" >> "$FILE"
    echo "storeFile=<keystore-file-location>" >> "$FILE"
fi
