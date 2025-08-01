#!/usr/bin/env bash
# Handle open -s && open -t with bemenu

#:bind o spawn --userscript /path/to/userscripts/qutedmenu open
#:bind O spawn --userscript /path/to/userscripts/qutedmenu tab

# If you would like to set a custom colorscheme/font use these dirs.
# https://github.com/halfwit/dotfiles/blob/master/.config/dmenu/bemenucolors

readonly confdir=${XDG_CONFIG_HOME:-$HOME/.config}
readonly optsfile=$confdir/dmenu/bemenucolors

create_menu() {
	# Check quickmarks
	while read -r url; do
		printf -- '%s\n' "$url"
	done <"$QUTE_CONFIG_DIR"/quickmarks

	# Next bookmarks
	while read -r url _; do
		printf -- '%s\n' "$url"
	done <"$QUTE_CONFIG_DIR"/bookmarks/urls

	# Finally history
	printf -- '%s\n' "$(sqlite3 -separator ' ' "$QUTE_DATA_DIR/history.sqlite" 'select title, url from CompletionHistory')"
}

get_selection() {
	opts+=(-p qutebrowser)
	create_menu | dmenu -l 10 "${opts[@]}"
	#create_menu | bemenu -l 10 "${opts[@]}"
}

# Main
# https://github.com/halfwit/dotfiles/blob/master/.config/dmenu/font
[[ -s $confdir/dmenu/font ]] && read -r font <"$confdir"/dmenu/font

[[ -n $font ]] && opts+=(-fn "$font")

# shellcheck source=/dev/null
[[ -s $optsfile ]] && source "$optsfile"

url=$(get_selection)
url=${url/*http/http}

# If no selection is made, exit (escape pressed, e.g.)
[[ -z $url ]] && exit 0

case $1 in
open) printf '%s' "open $url" >>"$QUTE_FIFO" || qutebrowser "$url" ;;
tab) printf '%s' "open -t $url" >>"$QUTE_FIFO" || qutebrowser "$url" ;;
window) printf '%s' "open -w $url" >>"$QUTE_FIFO" || qutebrowser "$url --target window" ;;
private) printf '%s' "open -p $url" >>"$QUTE_FIFO" || qutebrowser "$url --target private-window" ;;
esac
