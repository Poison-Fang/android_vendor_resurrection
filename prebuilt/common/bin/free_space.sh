#!/sbin/sh
#
# www.osbusters.net
#
# This script should be flashed after ROM installation.
# It will check for large apps in system and move it to data.
#
# This will neither delete any app nor will it break its functionality
# This will increase free space in system partition
#
# AUTHOR: nitesh9 (Nitesh Prasad)
# Modified by Poison-Fang (Ayush Walia)
outfile="/tmp/recovery.log"

# Cleanup Stuff
rm -rf "/data/system_app"
rm -rf "/data/dex_preopt"

# Create separate directories in /data
mkdir -p "/data/system_app"
chmod 755 "/data/system_app"
mkdir -p "/data/dex_preopt"
chmod 755 "/data/dex_preopt"

# Mount /system and /data
echo "#####START mounting system and data" >> ${outfile} 2>&1
mount | grep " /system " || /sbin/mount /system >> ${outfile} 2>&1
mount | grep " /data " || /sbin/mount /data >> ${outfile} 2>&1
mount >> ${outfile} 2>&1
df -h >> ${outfile} 2>&1
echo "#####END mounting system and data" >> ${outfile} 2>&1
# Moving files to data partition
# From system/app folder
cp -rf "/system/app/webview" "/data/system_app/webview"
rm -rf "/system/app/webview"
cp -rf "/system/framework/arm64" "/data/dex_preopt/arm64"
rm -rf "/system/framework/arm64"
cp -rf "/system/framework/arm" "/data/dex_preopt/arm"
rm -rf "/system/framework/arm"
cp -rf "/system/framework/oat" "/data/dex_preopt/oat"
rm -rf "/system/framework/oat"
# Set back permissions and symlink (the copied file has the same permissons, still doing for precaution)
# webview
chmod 755 "/data/system_app/webview"
chmod 644 "/data/system_app/webview/webview.apk"
chmod -R 755 "/data/dex_preopt"
ln -sf "/data/system_app/webview" "/system/app/webview"
ln -sf "/data/dex_preopt/arm64" "/system/framework/arm64"
ln -sf "/data/dex_preopt/arm" "/system/framework/arm"
ln -sf "/data/dex_preopt/oat" "/system/framework/oat"

