fdupes -r %f | tr --squeeze-repeats '\n' | sed 's/^/FALSE\n/g' | zenity --list --title="Supprimer les Fichiers Doublons" --column=" " --column="Fichiers en double" --width=800 --checklist --separator="\n" > /tmp/.fdupes-zenity && zenity --question --width=600 --title="Supprimer les fichiers sélectionnés?"; if [ $?=0 ];then cat /tmp/.fdupes-zenity | xargs -I {} rm "{}" ;else exit 0;fi