#! /bin/sh

for i in `seq 1 20`
	do
		file=`expr $i \* 256`
		echo $file
		if [ $i -lt 4 ]; then
			file="0"$file
		fi
		cp ./hmac_org.py $file"_hmac.py"
	done


