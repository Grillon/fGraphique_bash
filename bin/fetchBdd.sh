#!/bin/sh
if [ $# -ne 1 ];then 
	echo "veuillez fournir le fichier a sourcer svp"
	exit 251
fi
source=$1
source $(pwd)/${source}
rrdtool fetch ${bdd}.rrd AVERAGE --start ${debut} --end ${fin} -r 300
