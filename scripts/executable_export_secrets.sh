cat <<EOF >~/.env
# Bluetooth
export BEATS_PRO_MAC_ADDR="$(op read 'op://Personal/beats-pro-mac-addr/password')"
# GitHub
export GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN="$(op read 'op://Personal/7cxogiqeiaehpkdi4djb3yvn24/password')"
# VPN
export HOME_DDNS_NAME="$(op read 'op://Personal/hfg6pheaifln27gpjqfygrgmsu/ddns_hostname')"
EOF

cat <<EOF >~/.env.fish
# Bluetooth
set -gx BEATS_PRO_MAC_ADDR "$(op read 'op://Personal/beats-pro-mac-addr/password')"
# GitHub
set -gx GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN "$(op read 'op://Personal/7cxogiqeiaehpkdi4djb3yvn24/password')"
# VPN
set -gx HOME_DDNS_NAME "$(op read 'op://Personal/hfg6pheaifln27gpjqfygrgmsu/ddns_hostname')"
EOF

# TODO: Create another script to run to export jira env vars if work comp
