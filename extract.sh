#!/bin/bash

# Getting directory where file resides
SCRIPT=$(readlink -f $0)
ROOTDIR=`dirname $SCRIPT`

# Getting passed parameter
shopt -s extglob
URL=${1##*( )}
URL=${URL%%*( )}
OUTPUT=${2##*( )}
OUTPUT=${OUTPUT%%*( )}
shopt -u extglob

# Defining file to temporarily hold data from the url
TEMPFILE="$ROOTDIR/buffer.temp"

# Checking whether parameter is passed
if [[ -z "$URL" ]]; then
	echo "You need to define the link to rir delegation source"
	exit 1
fi

if [[ -z "$OUTPUT" ]]; then
	echo "You need to define the output file"
	exit 1
else
	if [[ -e "$OUTPUT" ]]; then
		echo "Output file exist, please choose different output file name"
		exit 1
	fi
fi

if [[ -e "$TEMPFILE" ]]; then
	rm -rf $TEMPFILE
fi

curl --fail -o $TEMPFILE $URL