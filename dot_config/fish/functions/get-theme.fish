function get-theme
  jq --raw-output '.theme' $XDG_STATE_HOME/theme-toggle/state.json
end
