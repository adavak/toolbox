#!/bin/bash
RED="\033[01;34m"
NC="\033[000m"

_RemoveInsecurePackages() {
	echo -e "$RED ###### REMOVING PACKAGES WITH SECURITY ISSUES $NC"
	echo -e "$RED ##### HIGH urgency $NC"
	echo -e "$RED ##### security issues per package $NC"
	vulns=$(debsecan | grep --color=always "remotely exploitable, high urgency"| egrep -v "($(uname -r)|image-.86|image-amd64)")
	displayvulns=$(echo "$vulns" | cut -d" " -f1 --complement | sort | cut -d" " -f1 |uniq -c)
#	echo -e "$vulns"
	echo "$displayvulns"

	echo -e "$RED ##### Please check for packages you don't want to uninstall! $NC"
	packages_to_remove=$(echo "$vulns" | awk -F" " '{print $2}')
	aptitude purge $packages_to_remove
}

_ZenityWrapper() {
	vulns=$(debsecan | grep --color=always "remotely exploitable, high urgency"| egrep -v "($(uname -r)|image-.86|image-amd64)")
	displayvulns=$(echo "$vulns" | cut -d" " -f1 --complement | sort | cut -d" " -f1 |uniq -c|sed 's/      //g'| tr " " "\nà")

	echo "$displayvulns" | zenity --list \
	--column "Failles" --column "Paquet" \
	--text "Packages with <b>High</b> priority + <b> Remotely Exploitable</b> vulnerabilities." \
	--title "Failles de sécurité" \
	--window-icon=/usr/share/icons/gnome/32x32/status/dialog-warning.png \
	--height=367 \
	--ok-label "Détails..." \
	--cancel-label "Quitter"

	if [ $? = 0 ] #TODO better display
		then
		text=$(echo "$vulns" | cut -d " " -f1-2 | while read line; do echo "http://www.cvedetails.com/cve/$line"; done)
		zenity --text "Vulnerable packages - Details" --list --column=URL --column=Package $text
	fi
}

# https://security-tracker.debian.org/tracker/

_ZenityWrapper