#!/usr/bin/env make

all: update

update: update_repo submodules downloads

update_repo:
	git fetch

submodules:
	git submodule update --init
	git fetch
	-git submodule foreach git checkout master
	-git submodule foreach git branch --set-upstream-to=origin/master master
	git submodule foreach git pull

downloads: downloads_linux downloads_windows downloads_macos glim
	cd dbu && make update
	cd glim && ./download-linux-distributions.sh debian centos tails
	cd github-stars-backup; ./github-backup-stars nodiscc
	#-cd SUBMODULES/themes-icons; make

# Releases RSS feeds
# https://github.com/vrana/adminer/releases.atom
# https://github.com/Dynalon/mdwiki/releases.atom
# https://github.com/tim-lebedkov/npackd-cpp/releases.atom
# https://github.com/jliljebl/flowblade/releases.atom
# https://github.com/dyson/indicator-workspaces/releases.atom
# https://github.com/EionRobb/pidgin-opensteamworks/releases.atom

downloads_linux:
	cd BINARIES/LINUX && make downloads_linux

downloads_windows:
	cd BINARIES/WIN && make downloads_windows

downloads_macos:
	cd BINARIES/MACOS && make downloads_macos

################################################
# extra

optimize:
	git submodule foreach git gc --aggressive

install:
	sudo cp \
	LINUX/git-fat/git-fat \
	LINUX/man2pdf \
	LINUX/image-grid \
	LINUX/uriencode \
	LINUX/uridecode \
	LINUX/gamma-normal gamma-low\
	LINUX/datehelp \
	LINUX/blackhole \
	LINUX/bugsubscribe \
	LINUX/snip \
	LINUX/tail-singleline \
	LINUX/torrent2magnet \
	/usr/local/bin/
	#npm install resume # CV/resume generator based on JSON http://jsonresume.org/
	#npm install peerflix # Streaming torrent client
	#npm install -g bower # A package manager for the web https://bower.io/
	#npm install -g generator-bespoke #  DIY Presentation Micro-Framework https://github.com/bespokejs/bespoke
	#gem install --no-ri --no-rdoc fpm # https://github.com/jordansissel/fpm package format converter
	#sudo aptitude install python3-stdeb python3-all-dev; for i in pyocr pyinsane2 pypillowfight paperwork-backend paperwork; do sudo pypi-install $i; done; paperwork-shell chkdeps paperwork_backend; paperwork-shell chkdeps paperwork # https://github.com/jflesch/paperwork - paper document scanning/OCR/search/management

mediawiki_archiver:
	#git -c remote.origin.mediaImport=true clone --depth=1 mediawiki::http://en.wikiaudio.org
	#git -c remote.origin.mediaImport=true clone --depth=1 mediawiki::http://www.appropedia.org
	#git -c remote.origin.mediaImport=true clone --depth=1 mediawiki::http://www.sigidwiki.com/wiki
	#git -c remote.origin.mediaImport=true clone --depth=1 mediawiki::https://en.wikibooks.org/wiki
	#git -c remote.origin.mediaImport=true clone --depth=1 mediawiki::https://wiki.archlinux.org/wiki
	#git -c remote.origin.mediaImport=true clone --depth=1 mediawiki::https://www.thomas-krenn.com/en/wiki
	#git -c remote.origin.mediaImport=true clone --depth=1 mediawiki::http://www.funtoo.org/
	#git -c remote.origin.mediaImport=true clone --depth=1 mediawiki::http://www.freebsdwiki.net/ #CLOSING SOON!!
	#git -c remote.origin.mediaImport=true clone --depth=1 mediawiki::https://wiki.openstreetmap.org/wiki/
	#git -c remote.origin.mediaImport=true clone --depth=1 mediawiki::http://wikiindex.org/
	#git -c remote.origin.mediaImport=true clone --depth=1 mediawiki::http://wiki.hydrogenaud.io/
	#git -c remote.origin.mediaImport=true clone --depth=1 mediawiki::http://wiki.linuxquestions.org/wiki
	#git -c remote.origin.mediaImport=true clone --depth=1 mediawiki::http://wiki.linuxaudio.org/wiki/
	#git -c remote.origin.mediaImport=true clone --depth=1 mediawiki::https://libregamewiki.org/
	#git -c remote.origin.mediaImport=true clone --depth=1 mediawiki::https://fr.wikisource.org/wiki/
	#git -c remote.origin.mediaImport=true clone --depth=1 mediawiki::https://fr.wiktionary.org/wiki/
