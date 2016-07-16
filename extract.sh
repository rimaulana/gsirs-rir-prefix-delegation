#!/bin/bash
# .SYNOPSIS
#	Convert RIR prefix delegation file into CSV file
# .EXAMPLE 1
#	./extract.sh ipv4 > output.csv 
#	the command above will extract all ipv4 delegation and convert
#	it into CSV file in output.csv
# .EXAMPLE 2
#	./extract.sh ipv4 /home/rio/url.list > output.csv 
#	read from specified url.list file
# .NOTES
#	Author		: Rio Maulana
#	Created		: July 15th, 2016

# Getting directory where file resides
SCRIPT=$(readlink -f $0)
ROOTDIR=`dirname $SCRIPT`

# Getting passed parameter
shopt -s extglob
TYPE=${1##*( )}
TYPE=${TYPE%%*( )}
LIST=${2##*( )}
LIST=${LIST%%*( )}
shopt -u extglob

# Defining file to temporarily hold data from the url
TEMPFILE="$ROOTDIR/buffer.temp"

# Checking whether parameter is passed
if [[ -z "$TYPE" ]]; then
	echo "You need to define the type of information you want to extract (asn or ipv4 or ipv6)"
	exit 1
fi

# Checking whether url list file is defined
# if not then it will set it to default url list path
if [[ -z "$LIST" ]]; then
	if [[ -e "$ROOTDIR/url.list" ]]; then
		LIST="$ROOTDIR/url.list"
	else
		echo "Couldn't find url list file, please specify"
		exit 1
	fi
fi

# read each url specified in url list file
while read URL; do

	# Delete temporary file if exist
	if [[ -e "$TEMPFILE" ]]; then
		rm -rf $TEMPFILE
	fi

	# download content of url into temporary file
	curl -s -o $TEMPFILE $URL > /dev/null

	# Read each line from temporary file
	while read LINE; do
		echo $LINE | awk -v extract="$TYPE" -F'|' '{
			if ($3 == extract && $2 != "*")
				print $1","$4","$2
	  	}'
	done < $TEMPFILE
done < $LIST

# Delete temporary file
rm -rf $TEMPFILE
