#!/bin/bash
# Description: create a directory containing manpages as HTML pages, and generate an index
# TODO: group all output in one file, TOC linking to anchors for every command
# TODO: add "help" pages to output
# TODO: add plain text files to output
# set -o errexit
# set -o nounset
# set -x

export LANG=C #use english, workaround encoding problems
workdir="manpages" #output directory
tochtml="<html><body><ul>" #html header for TOC
missingman="" #initialize list of missing manpages






 ##########################################

if [ ! -d $workdir ]; then mkdir $workdir; fi
cd $workdir

for command in $SYSADMIN_COMMANDS $TEXTHANDLING_COMMANDS $MISC_COMMANDS $NET_COMMANDS $MEDIA_COMMANDS
do
	location=$(man -w $command)
	echo $location
	if [ "$location" != "" ]
		then
			zcat $location | roffit  > $command.html
			tocentry=$(man -f $command)
			tocentry="<li><a href=$command.html>$tocentry</a></li>"
			tochtml="$tochtml $tocentry"
		else
			missingman="$missingman $command"

	fi
done

tochtml="$tochtml</ul><p>missing: $missingman</p></body></html>"
echo "$tochtml" >| index.html


# 	man -f $page
# 	man -t $page | ps2pdf - -> $page.pdf; done

# for page in $TEXT_FILES; do enscript -p - $page | ps2pdf - -> `basename $page`.pdf; done

# for page in $HELP_COMMANDS; do help $page | enscript --encoding=ps -p - | ps2pdf - -> $page.pdf; done


#man -t $COMMAND | ps2pdf - $COMMAND.pdf
#enscript to convert text files to ps
#ps2pdf to convert ps files to pdf
#pdfunite to merge pdf files

#How do I create a table of contents? a pdf index?
