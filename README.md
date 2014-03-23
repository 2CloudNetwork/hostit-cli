Host-it.tk CLI

Download the `host-it.sh` file and make it executable with `chmod +x`

Usage:
```
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
```

If you want to access the file globally, use:
```
mv host-it.sh /usr/local/bin/hostit

-----
After that you can use hostit -f .... from anywhere on your system.
```

[ TEST ]