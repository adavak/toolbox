#!/bin/bash
# Copy a .torrent to the same directory as it's files on download completion (transmission)
# See https://trac.transmissionbt.com/wiki/Scripts
# License: Public Domain
partialhash=$(echo "$TR_TORRENT_HASH" | cut -b 1-16)
cp "$HOME/.config/transmission/torrents/$TR_TORRENT_NAME.$partialhash.torrent" "$TR_TORRENT_DIR/"