#!/bin/bash
# Extracts links from a Firefox bookmarks export, archives them locally for offline browsing
# Creates an HTML index of the archive
# Usage: bookmark-archiver.sh input_file.html
# License: WTFPL http://www.wtfpl.net/
# Status: prototype
#
# TODO USE AN XML/HTML PARSER!!
# TODO rewrite in python https://github.com/shaarli/python-shaarli-client/issues/24 https://github.com/nodiscc/shaarchiver/blob/master/bookmarks-fetcher.py
# TODO add TAGS= field handling
# TODO add download_video/download_audio extractors alongside download_page
#		allow specifying tags to run the extractor on
#		allow blacklisting url patterns
#		allow blacklisting by tag
# TODO rate limit or limit the number of links that can be downloaded in a single run
# TODO add caching mechanism
# TODO deduplicate with jdupes/hardlinks (83M -> 57M)
# TODO blacklist all but one font format eot,ttf,woff...
# TODO add adblocker and compare total download sizes
# TODO add generic filtering/blacklist mechanism
#
######################################################
set -o errexit
set -o nounset
set -o pipefail
html_input_file="$1"
######################################################
# Config
force_retry_failed="no" # if no, don't retry downloading failed items
html_output_append="no" # if no, html output file will be overwritten
archive_directory="./DOC" # archive base directory
html_output_file="$archive_directory/index.html" # main archive HTML index file
failed_urls_list="$archive_directory/failed_urls.list" 
downloaded_urls_list="$archive_directory/downloaded_urls.list"
wget_useragent='Mozilla/5.0 (Windows NT 6.1; rv:57.0) Gecko/20100101 Firefox/57.0'

######################################################

html_header=\
'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<!-- Minimal html template thanks to http://www.sitepoint.com/a-minimal-html-document/ -->
<html lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8">
	<title>title</title>
	<link rel="stylesheet" type="text/css" href="style.css">
	<script type="text/javascript" src="script.js"></script>
	<style>
		body {
		    font-size: 8;
		}
	</style>
</head>
<body>
<table style="width:100%">
<tr>
	<th>URL</th>
	<th>TITLE</th>
	<th>DATE</th>
	<th>ARCHIVE</th>
</tr>'

###################################################################################################

function write_html_output() { 
	# write the archive index.html
	if [[ "$html_output_append" == "no" ]];	then echo -n "" >| "$html_output_file";	fi
	echo "$html_header"
	
	cat "$html_input_file" | while read line; do
		if [[ "$line" == *'<DT><H'* ]]; then write_html_heading "$line"
		elif [[ "$line" == *'HREF='* ]]; then write_html_link "$line"
		fi
	done
	
	echo -e '</body>\n</html>'
}


function write_html_heading() {
	# write a heading in the archive index (bookmark folders)
	line="$1"
	heading=$(echo "$line" | awk -F">" '{print $3}')
	html_heading="<tr><td><b>### $heading ###</b></td><td> </td><td> </td></tr>"
	echo "$html_heading"
}


function write_html_link() {
	# parse a netscape html link entry, format it and write it to the archive index
	line="$1";
	link_title=$(echo "$line" | sed -n 's/.*">\([^<]*\).*/\1/p')
	link_url=$(echo "$line" |sed -n 's/.*HREF="\([^"]*\).*/\1/p')
	link_date=$(echo "$line" | sed -n 's/.*ADD_DATE="\([^"]*\).*/\1/p')
	link_urlhash=$(echo -n "$link_url" | md5sum | cut -d" " -f1)
	link_fullpath=$(echo -n "$link_url" | sed --regexp-extended 's|^http(s)?://||g')
	
	# fix formatting differences between original URL and wget downloaded files
	if [[ "$link_fullpath" =~ .*/$ ]]; then
		link_fullpath="${link_fullpath}index.html"
	elif [[ ! "$link_fullpath" =~ .*htm(l)?$ ]]; then
		link_fullpath="$link_fullpath.html"
	else echo "DEBUG: $line does not match any known url pattern" #TODO
	fi
	
	html_entry="<tr><td>$link_title</td><td><a href=\"$link_url\">$link_url</a></td><td><a href=\"$link_urlhash/$link_fullpath\">archive</a></td></tr>"
	echo "$html_entry"
}


function download_all_links() {
	# generate a hash of each URL in the netscape bookmarks file, use it as download destination directory
	all_urls=$(cat "$html_input_file" |sed -n 's/.*HREF="\([^"]*\).*/\1/p')
	for link_url in $all_urls; do
		link_urlhash=$(echo -n "$link_url" | md5sum | cut -d" " -f1)
		download_page "$link_url" "$link_urlhash"
	done
}


function check_already_downloaded() {
	# check if an URL has already been downloaded/has failed
	link_url="$1"
	if grep "^${link_url}$" "$downloaded_urls_list" >/dev/null; then already_downloaded="true"
	elif [[ "$force_retry_failed" == "no" ]] && grep "^${link_url}$" "$failed_urls_list" >/dev/null; then already_downloaded="true"
	else already_downloaded="false"
	fi
}


function download_page() {
	# download a web page with wget
	link_url="$1"
	link_urlhash="$2"
	check_already_downloaded "$link_url"
	if "$already_downloaded" = "false" ; then
		echo "[info] already downloaded $link_url"
	else
		echo "[info] downloading $link_url"
		# Note: see also --accept="pdf,jpg,png,gif,svg,css,js,html,htm,mp3,ogg,mp4,opus,ogv,avi,mov,mp4"
		# Note: --mirror is shorthand for --recursive --timestamping --level=inf
		wget \
		--progress=dot -e robots=off --timeout=10 --tries=3 --waitretry=1 --no-verbose \
		--page-requisites --span-hosts --convert-links \
		--adjust-extension --no-parent --user-agent="$wget_useragent" \
		--reject woff,ttf,eot,woff2 --reject-regex '.*gravatar.*' \
		--directory-prefix="$archive_directory/$link_urlhash" \
		"$link_url" && echo "$link_url" >> "$downloaded_urls_list" || echo "$link_url" >> "$failed_urls_list"
	fi
}


_main() {
	if [[ ! -f "$downloaded_urls_list" ]]; then echo > "$downloaded_urls_list"; fi
	write_html_output | tee -a "$html_output_file"
	download_all_links
}

#######################################

_main



