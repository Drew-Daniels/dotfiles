#!/usr/bin/env bash

# https://github.com/qutebrowser/qutebrowser/blob/c79257dc8d55b5dba0eb32428067593b409f9dff/misc/userscripts/dmenu_qutebrowser

# SPDX-FileCopyrightText: Zach-Button <zachrey.button@gmail.com>
# SPDX-FileCopyrightText: Florian Bruhin (The Compiler) <mail@qutebrowser.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Pipes history, quickmarks, and URL into dmenu.
#
# If run from qutebrowser as a userscript, it runs :open on the URL
# If not, it opens a new qutebrowser window at the URL
#
# Ideal for use with tabs_are_windows. Set a hotkey to launch this script, then:
# :bind o spawn --userscript dmenu_qutebrowser
#
# Use the hotkey to open in new tab/window, press 'o' to open URL in current tab/window
# You can simulate "go" by pressing "o<tab>", as the current URL is always first in the list
#
# I personally use "<Mod4>o" to launch this script. For me, my workflow is:
# Default keys    Keys with this script
# O     <Mod4>o
# o     o
# go      o<Tab>
# gO      gC, then o<Tab>
#       (This is unnecessarily long. I use this rarely, feel free to make this script accept parameters.)
#

[ -z "$QUTE_URL" ] && QUTE_URL='https://duckduckgo.com'

url=$(printf "%s\n%s" "$QUTE_URL" "$(sqlite3 -separator ' ' "$QUTE_DATA_DIR/history.sqlite" 'select title, url from CompletionHistory')" | cat "$QUTE_CONFIG_DIR/quickmarks" - | wofi -S dmenu)
url=$(echo "$url" | sed -E 's/[^ ]+ +//g' | grep -E "https?:" || echo "$url")

[ -z "${url// /}" ] && exit

echo "open $url" >>"$QUTE_FIFO" || qutebrowser "$url"
