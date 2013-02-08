#!/bin/ksh
OLDIFS=$IFS;
function nommerConf
{
	touch tempo.$$;
	trap "/bin/rm tempo.$$;echo \"arret volontaire 253\";exit 253" HUP INT TERM;
        dialog --inputbox "quel nom de fichier souhaitez-vous?" 10 30 "$fConf" 2>tempo.$$;
        fConf="$(cat<tempo.$$)";
        if [ "${#fConf}" -gt 0 ];then touch $fConf;fi
	/bin/rm tempo.$$;
}
function creerConf
{
echo "#nom de bdd
bdd=essai
#nom du fichier d'index
cIndex=fvar2
#nom du fichier de creation de la base
aFaire=aFaire
debut=1331683200
fin=1334322000
#dans le language rrdtool "step" en seconde
pas=3600
#vitesse de maj rrdtool update(combien d'elements à chaque commande)
mIter=1
#fichier de maj
fMAJ=go.sh
#fichier xfrs
fXfrs=xfrsGLOBAL.asc
#fichier xfrs modifié qui devient donc le fichier d'entree contenant les donnees
fEntre=entre">$fConf
}
function ouvrirConf
{
mkfifo pipe1;
touch tempo.$$;
exec 3<> pipe1;
exec 4> tempo.$$;
trap "/bin/rm tempo.$$;print \"arret volontaire 253\";exit 253" HUP INT TERM
if [ -e $fConf ];then
        IFS=\=;
        while read a b;
        do
		if [[ $a == +(#*) ]];then titre="$a";
                elif [[ $a == !(#*) ]];then
                        if [[ $a == +(debut|fin) ]];then
				print $titre;
				print -n -u 3 "$a=";
                                dialog --calendar "$titre - $a" 0 0 $(date -d @$b '+%d=%m=%Y') 2>&3; 
				print -u 3 "-";
                        else          
				print $titre;
				print -n -u 3 "$a=";
                                dialog --inputbox "$titre - $a" 10 30 $b 2>&3
				print -u 3 "-";
			fi
                else print -u 3 "probleme"
                fi
        done<$fConf;
	IFS=$OLDIFS;
	while read -u 3 ligne;
	do
		print -u 4 "$ligne"
	done
fi     
       
cat tempo.$$>$fConf;
3<&-
4<&-
IFS=$OLDIFS;
/bin/rm tempo.$$
/bin/rm pipe1
}
