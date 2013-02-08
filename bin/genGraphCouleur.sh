#!/bin/sh
if [ $# -ne 1 ];then
        echo "merci d'entrer le nom du fichier de configuration à sourcer"
        exit 251
fi
#chargement de l'index des champs à dessiner cet index est different de celui de creation de la base
#c pour couleur; ça va de 1 a 9. inutile de dessiner plus de 9 variable je pense
source=$1
source $(pwd)/${source}
IFS=\|;
while read ligne;
        do set ${ligne};
        if [ -z "${xIndex}" ];then
                xIndex=$1;
		yIndex=$1-$2;
        else
                xIndex="${xIndex}|$1"
                yIndex="${yIndex}|$1-$2"
        fi
        done<${gIndex}
#chargement des couleurs
while read ligne;
        do set ${ligne};
        if [ -z "${couleur}" ];then
                couleur=$1;
        else
                couleur="${couleur}|$1"
        fi
        done<${fCouleur}
#graphique entrees - sorties
echo "rrdtool graph ${titre}.png --start ${debut} --end ${fin} \\">${aFaire}
echo "-t \"${titre} - ${bdd}\" \\">>${aFaire}
echo "-v ${unite} \\">>${aFaire}
echo "-w 2048 -h 500 \\">>${aFaire}
for x in ${xIndex};do 
	echo "DEF:v$x=${bdd}.rrd:$x:AVERAGE \\">>${aFaire};
done
for x in ${yIndex};do
	exIFS=${IFS}
	IFS=-
	set $x
	nCouleur=$((${nCouleur}+1))
	num=$1
	nom=$2
	IFS=${exIFS}
	set ${couleur}
	eval eval aCouleur="\$\{${nCouleur}\}"
	echo "LINE1:v${num}${aCouleur}:\"${nom}\" \\">>${aFaire};
done
for x in ${yIndex};do
	exIFS=${IFS}
        IFS=-
        set $x
        echo "GPRINT:v$1:MAX:\"$2 Max\: %5.2lf ${unite}\" \\">>${aFaire};
	IFS=${exIFS}
done
