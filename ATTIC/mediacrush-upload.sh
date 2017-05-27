#!/bin/bash
# MediaCrush (https://mediacru.sh) uploader
# Jerome Leclanche <jerome.leclanche+mediacrush@gmail.com>
#Description: Upload files to https://mediacru.sh

version=1.1.1
server="https://mediacru.sh"
create_album=false
dry_run=false
recursive=false
uploads=""

usage() {
    cat << EOF
usage: $(basename $0) $version [options] [files...]
Upload files to https://mediacru.sh
For more details see man mediacrush

  -a, --album             Create an album from the uploaded files
      --open              Open the uploaded images (or the album if there is one) in the browser
                            after upload has completed
      --dry-run           Do not upload, only display the urls the files would be uploaded to.
  -r, --recursive         Recursively upload directories
  -s, --server <server>   Specifies an alternate MediaCrush server. (Default: https://mediacru.sh)
  -h, --help              Display this help and exit
      --version           Output version information and exit
EOF
}

err() {
    echo
    echo "$@" 1>&2
}

if [[ $# -eq 0 ]]; then
    usage
    exit 1
fi

GETOPT=`getopt -o hars: --longoptions help,version,album,dry-run,open,recursive,server: -- "$@"`
if [[ $? != 0 ]]; then
    exit 1
fi

eval set -- "$GETOPT"

while true; do
    case "$1" in
        -h|--help)
            usage
            exit
            ;;
        --version)
            echo $(basename $0) $version
            exit
            ;;
        -a|--album)
            create_album=true
            shift 1
            ;;
        --dry-run)
            dry_run=true
            shift 1
            ;;
        --open)
            open_files=true
            shift 1
            ;;
        -r|--recursive)
            recursive=true
            shift 1
            ;;
        -s|--server)
            server="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error"
            exit 1
            ;;
    esac
done

xxdrp() {
	for i in `fold -2`; do
		echo -ne "\x${i}";
	done;
}


calculate_hash() {
    md5sum $1 | cut -d " " -f 1 | xxdrp | base64 | tr "+/" "-_" | cut -c 1-12
}

#Display desktop notifications and use clipboard, if available
notify() {
    if which notify-send >/dev/null && [[ ! -z "$DISPLAY" ]]
    then
        if [[ $message == *Uploaded:* || $message = *Album:* ]] && which xclip >/dev/null
            then
            echo "$server/$hash" | xclip -selection c
            notify-send -i gnome-screenshot "MediaCrush" "$message\nAddress copied to clipboard"
        fi
    else
        notify-send -i gnome-screenshot "MediaCrush" "$message"
    fi
}

upload() {
    for f in "$@"; do

        if [[ -d "$f" ]]; then
            if [[ $recursive == true ]]; then
                upload "$f/*"
            else
                err "omitting directory: $f"
                continue
            fi
        fi

        echo -n "Uploading $f ..."

        if [[ $dry_run == true ]]; then
            hash=$(calculate_hash $f)
            message="Uploaded: $server/$hash"
            echo -e "$message"
            notify
            continue
        fi

        url="$server/api/upload/file"
        out=$(curl --silent -F "file=@$f" "$url")

        if [[ $? -ne 0 ]]; then
            message="Could not upload to $url"
            err "$message"
            notify
            continue
        fi

        hash=$(echo $out | sed -nre 's#.*"hash": "([^"]+)".*#\1#p')
        error=$(echo $out | sed -nre 's#.*"error": ([0-9]+) .*#\1#p')

        if [[ $error == "415" ]]; then
            type=$(file --mime "$f")
            message="The file type for $type is not supported"
            err "$message"
            notify
            continue
        elif [[ $error == "420" ]]; then
            message="You are uploading too much, too fast. Try again later."
            err "$message"
            notify
            # abort everything, no sense trying to upload more
            exit 420
        fi

        if [[ $uploads == "" ]]; then
            uploads="$hash"
        else
            uploads="$uploads,$hash"
        fi

        message="Uploaded: $server/$hash"
        echo -e "$message"
        notify
    done

    if [[ $create_album == true ]]; then
        if [[ $dry_run == true ]]; then
            message="Album: (not available)"
            echo "$message"
            notify
        else
			message="Creating album..."
            echo "$message"
            notify
			out=$(curl --silent -F "list=$uploads" "$server/api/album/create")
			hash=$(echo $out | sed -nre 's#.*"hash": "([^"]+)".*#\1#p')
			message="Album: $server/$hash"
            echo -e "$message"
            notify

			if [[ $open_files == true ]]; then
				xdg-open "$server/$hash"
			fi
        fi
    elif [[ $open_files == true ]]; then
        for upload in "$uploads"; do
            xdg-open "$server/$upload"
        done
    fi
}

upload "$@"