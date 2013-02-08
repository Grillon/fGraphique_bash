#!/bin/sh
if [ $# -ne 1 ];then 
	echo "merci d'entrer le nom du fichier de conf à sourcer"
	exit  251
fi
function retireNonInt
{
awk -v entree=$entree -v sortie=$sortie -F\| 'BEGIN {
print "entree : "entree
print "sortie : "sortie
}
{
for (x=1;x<=NF;x++) {
        if (match($x,"[^0-9.]"))
        {
                if (length(resultat)== 0) {
                        resultat="^"x"\\|"
                }
                else resultat="^"x"\\|\|"resultat
        }
}
}
END {
print resultat
system("egrep -v \""resultat"\" "entree">"sortie)
}'

}
#if [ $# -ne 2 ];then
#	echo "merci d'entrer le fichier xfr{s,d} en argument 1" 
#	echo "ainsi que le fichier de sortie en argument 2"
#fi
source=$1
source $(pwd)/${source}
#fXfrs=$1
#fEntre=$2
awk '{if (NR>3) { gsub(" *","",$0);print $0}}' ${fXfrs}>${fEntre}
head -1 ${fEntre} | retireNonInt
