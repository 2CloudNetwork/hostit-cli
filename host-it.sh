#!/bin/bash

# Host-it.tk CLI by Steven <s-8@outlook.com>
#
# OPTIONS: [
# 
# 	-s = silent mode (Doesnt return any url - just uploads the file)
#	-f = file | example: -f demo.txt 
#               multiple files: -f demo1.txt -f demo2.txt ...
# ]
#

FILES=''
SILENT=false

API='http://host-it.tk/Upload.html'
QUERY=''

(( $# )) || printf '%s\n' 'Use: -s (silent mode) | -f (file)'

# Extract Value from JSON-String
# Ref: https://gist.github.com/cjus/1047794
function jsonval {
	temp=`echo $JSON | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $PROPERTY`
    echo ${temp##*|}
}

while getopts 'f:s' flag; do

  case "${flag}" in

  	s)

		if [ "$SILENT" = false ]; then

		    SILENT=true
		fi
	;;

    f) 
		FILES="${OPTARG}"

		if [ "$SILENT" = false ]; then

			if [ `builtin type -p curl` ]; then 

				for file in "${FILES[@]}"
				do
					if [ -s "$file" ]; then

						echo "ADDED: $file added to query"

						query+=" -F file=@$file"

					else
						echo "ERROR: $file does not exists / is invalid!"
					fi
				done

				if [ "$query" != "" ]; then

					echo "UPLOADING: $file"

					JSON=`curl -i -s $API $query`

					PROPERTY='Link'
					VALUE=`jsonval`

					echo "$VALUE"

				fi

			else 

				echo "CURL is not installed. Please install it. eg: apt-get install curl"; 
			fi
		fi
	;;

    *) 
		error "Unexpected option ${flag}" 
	;;
  esac
done