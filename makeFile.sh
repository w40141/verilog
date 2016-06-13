#! /bin/sh

if test 0 -lt $#
then
	echo "hello"
	mkdir $1
	cd $1
	mkdir work kairo
fi
