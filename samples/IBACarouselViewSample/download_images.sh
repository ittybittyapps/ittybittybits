#!/bin/sh
for i in `seq -w 1 72`; do
	url="http://www.apple.com/html5/showcase/threesixty/images/optimized/Seq_v04_640x378_$i.jpg"
	echo Downloading $url...
	curl $url  -o Resources/iPhoneImages/Seq_v04_640x378_$i.jpg
done