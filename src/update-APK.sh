#!/bin/sh

flutter build apk &&
rm ./latest-APK/app-release.apk &&
cp ./build/app/outputs/apk/release/app-release.apk ./latest-APK
