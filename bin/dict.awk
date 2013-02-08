#!/usr/bin/awk -f 
BEGIN {
if (length(choix) == 0){choix=rien}
else choix=choix
x=0
}
{
if ($0 ~ /^METRIC DEFINITIONS/) {zoneDef=1;}
if (zoneDef==1) {
        if ($0 ~ /^ [A-Z]+/)
        {
                if ($0 ~ choix)
                {
                        affiche=1;
                }
                else affiche=0;
        }
        if (affiche==1)
        {
                print $0;
        }
}
}
END {
x=choix;
}
