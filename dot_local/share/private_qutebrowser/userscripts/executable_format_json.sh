#!/bin/sh

set -eu
#
# Behavior:
#   Userscript for qutebrowser which will take the raw JSON text of the current
#   page, format it using `jq`, will add syntax highlighting using `pygments`,
#   and open the syntax highlighted pretty printed html in a new tab. If the file
#   is larger than 10MB then this script will only indent the json and will forego
#   syntax highlighting using pygments.
#
#   In order to use this script, just start it using `spawn --userscript` from
#   qutebrowser. I recommend using an alias, e.g.
#
#     :config-dict-add aliases json "spawn --userscript /path/to/json_format"
#
#   Note that the color style defaults to monokai, but a different pygments style
#   can be passed as the first parameter to the script. A full list of the pygments
#   styles can be found at: https://help.farbox.com/pygments.html
#
# Bryan Gilbert, 2017

# do not run pygmentize on files larger than this amount of bytes
MAX_SIZE_PRETTIFY=10485760 # 10 MB
# default style to monokai if none is provided
STYLE=${1:-monokai}

TEMP_FILE="$(mktemp --suffix .html)"
jq . "$QUTE_TEXT" >"$TEMP_FILE"

# try GNU stat first and then OSX stat if the former fails
FILE_SIZE=$(
  stat --printf="%s" "$TEMP_FILE" 2>/dev/null ||
    stat -f%z "$TEMP_FILE" 2>/dev/null
)
if [ "$FILE_SIZE" -lt "$MAX_SIZE_PRETTIFY" ]; then
  pygmentize -l json -f html -O full,style="$STYLE" <"$TEMP_FILE" >"${TEMP_FILE}_"
  mv -f "${TEMP_FILE}_" "$TEMP_FILE"
fi

# send the command to qutebrowser to open the new file containing the formatted json
echo "open -t file://$TEMP_FILE" >>"$QUTE_FIFO"
