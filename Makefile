#!/usr/bin/env make
SHELL := '/bin/bash'
WGET := wget -N -nv --show-progress
MEDIAWIKI_ARCHIVER_GIT_OPTIONS := -c remote.origin.mediaImport="true" -c remote.origin.shallow="true"

################

all: update

update: submodules mr downloads stat

submodules:
	git fetch
	git submodule update --init
	-git submodule foreach git checkout master
	-git submodule foreach git branch --set-upstream-to=origin/master master
	git submodule foreach git pull

mr:
	cd MIRRORS/GIT && mr -c mrconfig update

downloads: downloads_iso downloads_linux downloads_macos downloads_windows
	cd PROJECTS/dbu && make update
	-cd MIRRORS/GITHUB-STARS && ./github-stars-backup nodiscc && git add . && git commit -m "update" && git push
	#-cd SUBMODULES/themes-icons; make

downloads_iso:
	cd MIRRORS/BIN-ISO/ && ./download-linux-distributions debian centos

downloads_linux:
	#wget -N -nv --show-progress http://tiddlywiki.com/empty.html -O MIRRORS/BIN-LINUX/tiddlywiki-empty.html
	$(WGET) -P MIRRORS/BIN-LINUX/ https://downloads.lwks.com/lwks-12.6.0-amd64.deb
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/jliljebl/flowblade/releases/download/1.12.2/flowblade-1.12.0-1_all.deb
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/klembot/twinejs/releases/download/2.2.1/twine_2.2.1_linux64.zip
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/BurntSushi/xsv/releases/download/0.10.3/xsv-0.10.3-i686-unknown-linux-musl.tar.gz
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/Dynalon/mdwiki/releases/download/0.6.2/mdwiki-0.6.2.zip
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/feross/webtorrent-desktop/releases/download/v0.16.0/webtorrent-desktop_0.16.0-1_amd64.deb
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/gbevin/SendMIDI/releases/download/1.0.5/sendmidi-linux-1.0.5.zip
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/junegunn/fzf-bin/releases/download/0.15.9/fzf-0.15.9-linux_amd64.tgz
	#$(WGET) -P MIRRORS/BIN-LINUX/ https://get.popcorntime.sh/build/Popcorn-Time-0.3.10-Linux-64.tar.xz
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/github/hub/releases/download/v2.3.0-pre10/hub-linux-amd64-2.3.0-pre10.tgz
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/jliljebl/flowblade/releases/download/1.12.2/flowblade-1.12.0-1_all.deb
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/BurntSushi/xsv/releases/download/0.10.3/xsv-0.10.3-i686-unknown-linux-musl.tar.gz
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/Dynalon/mdwiki/releases/download/0.6.2/mdwiki-0.6.2.zip
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/feross/webtorrent-desktop/releases/download/v0.16.0/webtorrent-desktop_0.16.0-1_amd64.deb
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/gbevin/SendMIDI/releases/download/1.0.5/sendmidi-linux-1.0.5.zip
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/junegunn/fzf-bin/releases/download/0.15.9/fzf-0.15.9-linux_amd64.tgz
	$(WGET) -P MIRRORS/BIN-LINUX/ https://s3.amazonaws.com/Minecraft.Download/versions/1.11.2/minecraft_server.1.11.2.jar
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/vrana/adminer/releases/download/v4.6.1/adminer-4.6.1.php
	#$(WGET) -P MIRRORS/BIN-LINUX/ http://iographica.com/download/linux/IOGraph_v1_0_1.jar
	#$(WGET) -P MIRRORS/BIN-LINUX/ http://al.chemy.org/files/Alchemy-008.tar.gz
	# https://github.com/mank319/Go-For-It (see PPA for other files)
	#$(WGET) -P MIRRORS/BIN-LINUX/ http://ppa.launchpad.net/mank319/go-for-it/ubuntu/pool/main/g/go-for-it/go-for-it_1.4.7-0~142~ubuntu16.10.1_amd64.deb
	# http://www.qlcplus.org/
	#$(WGET) -P MIRRORS/BIN-LINUX/ http://www.qlcplus.org/downloads/4.11.0/qlcplus_4.11.0_amd64.deb
	# https://gottcode.org/kapow/ (see PPA for other files)
	#$(WGET) -P MIRRORS/BIN-LINUX/ http://ppa.launchpad.net/gottcode/gcppa/ubuntu/pool/main/k/kapow/kapow_1.5.5-0ppa1~zesty1_amd64.deb
	# https://github.com/dyson/indicator-workspaces
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/dyson/indicator-workspaces/releases/download/v0.5/indicator-workspaces_0.5_all.deb
	# https://www.sublimetext.com/3
	$(WGET) -P MIRRORS/BIN-LINUX/ https://download.sublimetext.com/sublime_text_3_build_3143_x64.tar.bz2
	$(WGET) -P MIRRORS/BIN-LINUX/ https://packagecontrol.io/Package%20Control.sublime-package
	# http://www.qownnotes.org/ (blocks wget user-agent)
	#$(WGET) -P MIRRORS/BIN-LINUX/ https://download.opensuse.org/repositories/home:/pbek:/QOwnNotes/Debian_9.0/amd64/qownnotes_18.02.0-1_amd64.deb
	# https://github.com/brrd/Abricotine
	# $(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/brrd/Abricotine/releases/download/0.5.0/Abricotine-linux-ubuntu-debian-x64.deb
	$(WGET) -P MIRRORS/BIN-LINUX/ https://downloads.tuxfamily.org/godotengine/2.1.3/Godot_v2.1.3-stable_x11.64.zip
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/mifi/lossless-cut/releases/download/v1.6.0/LosslessCut-linux-x64.zip
	# https://kiwix.org/ (blocks wget user-agent)
	# $(WGET) -P MIRRORS/BIN-LINUX/ https://download.kiwix.org/portable/wikipedia_fr_all.zip.torrent
	# $(WGET) -P MIRRORS/BIN-LINUX/ https://download.kiwix.org/portable/wikipedia_en_all.zip.torrent
	# https://rock-hopper.github.io/shuriken/ (blocks wget user-agent)
	# $(WGET) -P MIRRORS/BIN-LINUX/ https://download.opensuse.org/repositories/home:/RockHopper/Debian_9.0/amd64/shuriken_0.5.2-2stretch1_amd64.deb
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/mltframework/shotcut/releases/download/v17.09/shotcut-linux-x86_64-170904.tar.bz2
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/kmkolasinski/AwesomeBump/releases/download/Linuxv5.0/AwesomeBumpV5.Bin64Linux.tar.gz
	$(WGET) -P MIRRORS/BIN-LINUX/ https://github.com/artfwo/andes/releases/download/v0.1/Andes1-0.1-linux-x86_64.tar.gz
	# https://github.com/retext-project/retext
	$(WGET) -P MIRRORS/BIN-LINUX/ https://deb.debian.org/debian/pool/main/r/retext/retext_7.0.1-1_all.deb
	# https://www.lwks.com/ (non-free)
	#$(WGET) -P MIRRORS/BIN-LINUX/ https://downloads.lwks.com/lwks-12.6.0-amd64.deb
	# http://mapmap.info/ (see PPA for other files)
	#$(WGET) -P MIRRORS/BIN-LINUX/ http://ppa.launchpad.net/mapmap/mapmap/ubuntu/pool/main/m/mapmap/mapmap_0.4.0-1~trusty~ppa1_amd64.deb
	# https://code.visualstudio.com/ https://github.com/Microsoft/vscode
	#$(WGET) -P MIRRORS/BIN-LINUX/ https://az764295.vo.msecnd.net/stable/929bacba01ef658b873545e26034d1a8067445e9/code_1.18.1-1510857349_amd64.deb
	#$(WGET) -P MIRRORS/BIN-LINUX/ http://www.worldpainter.net/files/worldpainter_2.4.1.deb
	# https://launchpad.net/~tsbarnes/+archive/ubuntu/indicator-keylock (see PPA for other files)
	#$(WGET) -P MIRRORS/BIN-LINUX/ http://ppa.launchpad.net/tsbarnes/indicator-keylock/ubuntu/pool/main/i/indicator-keylock/indicator-keylock_3.0.2-0~ppa1_amd64.deb
    $(WGET) -P ATTIC/ https://public-dns.info/nameservers.csv

downloads_macos:
	$(WGET)  -P MIRRORS/BIN-MAC/ https://github.com/gbevin/SendMIDI/releases/download/1.0.5/sendmidi-macos-1.0.5.zip

downloads_windows:
	$(WGET) -P MIRRORS/BIN-WINDOWS/ https://github.com/tim-lebedkov/npackd-cpp/releases/download/version_1.23/Npackd64-1.23.msi
	$(WGET) -P MIRRORS/BIN-WINDOWS/ https://github.com/tim-lebedkov/npackd-cpp/releases/download/version_1.23/NpackdCL-1.23.msi
	$(WGET) -P MIRRORS/BIN-WINDOWS/ https://github.com/EionRobb/pidgin-opensteamworks/releases/download/1.6.1/libsteam-1.6.1.dll
	#$(WGET) -P MIRRORS/BIN-WINDOWS/ http://freealarmclocksoftware.com/FreeAlarmClockPortable.zip
	#$(WGET) -P MIRRORS/BIN-WINDOWS/ https://github.com/gbevin/SendMIDI/releases/download/1.0.5/sendmidi-windows-1.0.5.zip
	#$(WGET) -P MIRRORS/BIN-WINDOWS/ https://fpdownload.macromedia.com/pub/flashplayer/updaters/27/flashplayer_27_sa.exe
	#$(WGET) -P MIRRORS/BIN-WINDOWS/ http://www.world-machine.com/WM237_Basic.exe
	#$(WGET) -P MIRRORS/BIN-WINDOWS/ http://23.98.147.40/uploads/MagicaVoxel-0.98.1-win-mac-beta.zip
	#$(WGET) -P MIRRORS/BIN-WINDOWS/ https://github.com/mltframework/shotcut/releases/download/v17.09/shotcut-win64-170904.exe
	#$(WGET) -P MIRRORS/BIN-WINDOWS/ https://github.com/brrd/Abricotine/releases/download/0.5.0/Abricotine-setup-win32-x64.exe
	#$(WGET) -P MIRRORS/BIN-WINDOWS/ http://download.wsusoffline.net/wsusoffline1092.zip

stat:
	cd MIRRORS/GIT && mr -c mrconfig stat
	git status

#####################################################################

tumblr_backup:
	cd MIRRORS/TUMBLR/ && python ../GITHUB/tumblr_backup/tumblr_backup.py onethingwell.org
	
openstreetmap_backup:
	$(WGET) -P MIRRORS/MAPS/ https://download.geofabrik.de/europe/france-latest.osm.pbf


# Mirror mediawikis using https://github.com/Git-Mediawiki/Git-Mediawiki/
WIKI_MIRRORS := $(find "$$PWD/MIRRORS/WIKI/" -maxdepth 1 -mindepth 1 -type d)
mediawiki_archiver:
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::https://wiki.archlinux.org/
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::https://www.ekopedia.fr/
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://en.wikiaudio.org
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://wiki.step-project.com/
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://www.appropedia.org
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://www.sigidwiki.com/wiki
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::https://en.wikibooks.org/wiki
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::https://www.thomas-krenn.com/en/wiki
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://www.funtoo.org/
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://www.freebsdwiki.net/ #CLOSING SOON!!
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::https://wiki.openstreetmap.org/wiki/
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://wikiindex.org/
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://wiki.hydrogenaud.io/
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://wiki.linuxquestions.org/wiki
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://wiki.linuxaudio.org/wiki/
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::https://libregamewiki.org/
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::https://fr.wikisource.org/wiki/
	#-cd MIRRORS/WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::https://fr.wiktionary.org/wiki/
	# update already cloned mediawikis
	for i in $(WIKI_MIRRORS); do cd "$$i"; git pull --depth=1; done
	# http://elderscrolls.wikia.com/wiki/Special:Statistics
	$(WGET) -P MIRRORS/WIKI/ https://s3.amazonaws.com/wikia_xml_dumps/e/el/elderscrolls_pages_current.xml.7z

archlinux_wikipedia_spider:
	#Extract a list of all [[Wikipedia:...]] links from archwiki
	cd MIRRORS/WIKI/ && ./archlinux-wikipedia-links.sh

################################################

optimize:
	git submodule foreach git gc --aggressive

dbu:
	cd PROJECTS/dbu && make


#install:
	#npm install resume # CV/resume generator based on JSON http://jsonresume.org/
	#npm install peerflix # Streaming torrent client
	#npm install -g bower # A package manager for the web https://bower.io/
	#pip3 install --user pymdown-extensions # https://facelessuser.github.io/pymdown-extensions/#extensions
	#npm install -g generator-bespoke #  DIY Presentation Micro-Framework https://github.com/bespokejs/bespoke
	#gem install --no-ri --no-rdoc fpm # https://github.com/jordansissel/fpm package format converter
	#sudo aptitude install python3-pip python3-setuptools python3-dev python3-pil libenchant-dev python3-whoosh && sudo pip3 install paperwork && paperwork-shell chkdeps paperwork_backend && paperwork-shell chkdeps paperwork && paperwork-shell install # https://github.com/jflesch/paperwork - paper document scanning/OCR/search/management


