#!/bin/sh
choix=0;
while [ "$?" -ne 1 ]
do 
dialog --help-button --checklist "essai" 40 50 30 $(for i in $(cat index_metrique.txt);do OLDIFS=$IFS;IFS=\|;set $i;echo $2 $1 on;IFS=$OLDIFS;done) 2>titi
#dialog --help-button --checklist "essai" 40 50 30 $(for i in $(cat methp);do OLDIFS=$IFS;IFS=\|;set $i;echo $1 $2 no;IFS=$OLDIFS;done) 2>titi
choix=$(cat titi);
set $choix;
if [ "$1" == "HELP" ];then
	choix=$2
	choix=${choix%?};
	choix=${choix#?};
	dialog --msgbox "$(awk -v choix=$choix -f ~/bin/dict.awk methpux.txt)" 30 80 2>/dev/null;
else 
	dialog --msgbox "$choix" 30 80 
	choix=${choix// /\|}
	choix=${choix//\"/\\|}
	echo $choix>listeC;
	egrep -f listeC index_metrique.txt>fvar;
	break;
fi
done
