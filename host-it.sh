#!/bin/bash

# Host-it.tk CLI by Steven <s-8@outlook.com>
#
# OPTIONS: [
# 
# 	-s = silent mode (Doesnt return any url - just uploads the file)
#	-v = verbose (returns status information)
#	-f = file | example: -f demo.txt 
#               multiple files: -f demo1.txt -f demo2.txt ...
#
#	*if -v is not set, only the url returns*
# ]
#

FILES=""
SILENT=false
VERBOSE=false

API="http://host-it.tk/Upload.html"
QUERY=""

STATUS=""

(( $# )) || printf '%s\n' 'Use: -s (silent mode) | -v (verbose) | -f (file)'

# Extract Value from JSON-String
# Ref: https://gist.github.com/cjus/1047794
function jsonval {
	temp=`echo $JSON | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $PROPERTY`
    echo ${temp##*|}
}

while getopts 'f:sv' flag; do

  case "${flag}" in

	s)

		if [ "$SILENT" = false ]; then

		    SILENT=true
		fi
	;;

    	f) 
		FILES="${OPTARG}"

		if [ `builtin type -p curl` ]; then 

			for file in "${FILES[@]}"
			do
				if [ -s "$file" ]; then

					STATUS="ADDED: $file added to query"

					query+=" -F file=@$file"

				else
					echo "ERROR: $file does not exists / is invalid!"
				fi
			done

			if [ "$query" != "" ]; then
	
				STATUS+="\nUPLOADING: $file ..."

				if [ "$VERBOSE" = true ]; then
					
					echo -e "\n$STATUS"
				fi

				JSON=`curl --progress-bar -i -s $API $query`

				PROPERTY='Link'
				VALUE=`jsonval`

				if [ "$SILENT" = false ]; then

					echo "$VALUE"
				fi

			fi

		else 

			echo "CURL is not installed. Please install it. eg: apt-get install curl"; 
		fi
		
	;;

	v)

		if [ "$VERBOSE" = false ] && [ "$SILENT" = false ]; then

		    VERBOSE=true
		fi
	;;

    	*) 
		error "Unexpected option ${flag}" 
	;;
  esac
done
