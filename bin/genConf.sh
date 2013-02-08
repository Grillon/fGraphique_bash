#!/bin/ksh
source libGraph.sh
trap "rm tempo.$$" 2 3 15;
if [ $# -eq 1 ];then
    if [ -e $1 ];then
        fConf=$1;
        ouvrirConf $fConf;
    else
        echo "fichier inexistant"
        creerConf $fConf;
        ouvrirConf $fConf;
    fi;
else
    nommerConf;
    echo $fConf;
	nbl="$(wc -l $fConf)"
	nbl="${nbl% ${fConf}}"
    if [[ "${nbl}" -lt 5 ]];then
	dialog --msgbox "Attention le fichier $fConf fait $nbl , cela ne convient pas; contenu : $(cat $fConf)" 10 30 
	dialog --yesno "Souhaitez vous le rendre conforme?" 10 30;
	if [ $? -eq 0 ];then 
		creerConf $fConf;
	else 
		echo "Fichier fourni non conforme!"
		exit 252;
	fi
    fi
    ouvrirConf $fConf;
fi
exit 0;
