#!/bin/sh
# Script to generate a decent mkv from an mp4 and subs
# Correctly sets the language and disposition (default)
# of the subs.
# Also attempts to tag the subs in the mkv with a version
# tag, found in a (local directory) file 'version.txt'.

# args:
if [ $# -ne 3 ];then
	echo usage: gen.mkv.sh mp4.input ass.input mkv.output
	exit 1
fi
MP4=$1
ASS=$2
MKV=$3
echo .mp4 input : ${MP4}
echo .ass input : ${ASS}
echo .mkv output: ${MKV}

VERSION_FILE=version.txt
VERSION=$(cat ${VERSION_FILE})-$(git rev-parse --short HEAD)
echo tagging mkv with version ${VERSION}

# tools
FFMPEG=ffmpeg

# add the version string to a tmp version of this .ass
TMP_ASS=${ASS}.tmp.ass
cp ${ASS} ${TMP_ASS}
sed -i "s/\*\*version\*\*/v${VERSION}/g" ${TMP_ASS}

${FFMPEG} -y -i ${MP4} -i ${TMP_ASS} \
  -map 0:v -map 0:a -map 1 \
  -vcodec copy -acodec copy \
  -metadata:s:s:0 language=eng -disposition:s:0 default \
  ${MKV}

rm ${TMP_ASS}
