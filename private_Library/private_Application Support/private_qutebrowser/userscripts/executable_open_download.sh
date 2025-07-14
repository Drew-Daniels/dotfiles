#!/usr/bin/env bash
# Both standalone script and qutebrowser userscript that opens a wofi menu with
# all files from the download directory and opens the selected file. It works
# both as a userscript and a standalone script that is called from outside of
# qutebrowser.
#
# Suggested keybinding (for "show downloads"):
# spawn --userscript ~/.config/qutebrowser/open_download
#     sd
#
# Requirements:
#  - wofi (in a recent version)
#  - xdg-open and xdg-mime
#  - You should configure qutebrowser to download files to a single directory
#  - It comes in handy if you enable downloads.remove_finished. If you want to
#    see the recent downloads, just press "sd".
#
# Thorsten Wißmann, 2015 (thorsten` on Libera Chat)
# Any feedback is welcome!

set -e

# open a file from the download directory using wofi
DOWNLOAD_DIR=${DOWNLOAD_DIR:-$QUTE_DOWNLOAD_DIR}
DOWNLOAD_DIR=${DOWNLOAD_DIR:-$HOME/Downloads}
# the name of the wofi command
WOFI_CMD=${WOFI_CMD:-wofi}
WOFI_ARGS=${WOFI_ARGS:-}

msg() {
  local cmd="$1"
  shift
  local msg="$*"
  if [ -z "$QUTE_FIFO" ]; then
    echo "$cmd: $msg" >&2
  else
    echo "message-$cmd '${msg//\'/\\\'}'" >>"$QUTE_FIFO"
  fi
}
die() {
  msg error "$*"
  if [ -n "$QUTE_FIFO" ]; then
    # when run as a userscript, the above error message already informs the
    # user about the failure, and no additional "userscript exited with status
    # 1" is needed.
    exit 0
  else
    exit 1
  fi
}

if ! [ -d "$DOWNLOAD_DIR" ]; then
  die "Download directory »$DOWNLOAD_DIR« not found!"
fi
if ! command -v "${WOFI_CMD}" >/dev/null; then
  die "wofi command »${WOFI_CMD}« not found in PATH!"
fi

wofi_default_args=(
  -monitor -2 # place above window
  -location 6 # aligned at the bottom
  -width 100  # use full window width
  -i
  -no-custom
  -format i # make wofi return the index
  -l 10
  -p 'Open download:' -dmenu
)

crop-first-column() {
  local maxlength=${1:-40}
  local expression='s|^\([^\t]\{0,'"$maxlength"'\}\)[^\t]*\t|\1\t|'
  sed "$expression"
}

ls-files() {
  # add the slash at the end of the download dir enforces to follow the
  # symlink, if the DOWNLOAD_DIR itself is a symlink
  # shellcheck disable=SC2010
  ls -Q --quoting-style escape -h -o -1 -A -t "${DOWNLOAD_DIR}/" |
    grep '^[-]' |
    cut -d' ' -f3- |
    sed 's,^\(.*[^\]\) \(.*\)$,\2\t\1,' |
    sed 's,\\\(.\),\1,g'
}

mapfile -t entries < <(ls-files)

# we need to manually check that there are items, because wofi doesn't show up
# if there are no items and -no-custom is passed to wofi.
if [ "${#entries[@]}" -eq 0 ]; then
  die "Download directory »${DOWNLOAD_DIR}« empty"
fi

line=$(printf '%s\n' "${entries[@]}" |
  crop-first-column 55 |
  column -s $'\t' -t |
  $WOFI_CMD "${wofi_default_args[@]}" "$WOFI_ARGS") || true
if [ -z "$line" ]; then
  exit 0
fi

file="${entries[$line]}"
file="${file%%$'\t'*}"
path="$DOWNLOAD_DIR/$file"

if [ -f /.flatpak-info ]; then
  # with the help of the appchooser portal, flatpak let the user select the
  # app associated with a mime type after executing xdg-open.
  # we can't know ahead of time which app will be launched, and the sandbox
  # doesn't have access to mime types known to the host.
  msg info "Opening »$file« with XDG Desktop Portal"
else
  filetype=$(xdg-mime query filetype "$path")
  application=$(xdg-mime query default "$filetype")

  if [ -z "$application" ]; then
    die "Do not know how to open »$file« of type $filetype"
  fi

  msg info "Opening »$file« (of type $filetype) with ${application%.desktop}"
fi

xdg-open "$path"
