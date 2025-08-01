#!/usr/bin/env bash

if [[ $1 -eq 'list' ]] && [[ -z $QUTE_COUNT ]]; then
  PORTS="$(ss -nltp | tail -n +2 | awk '{print $4}' | awk -F: '{print $2}')"
  QUTE_COUNT=$(echo "$PORTS" | dmenu)
fi

echo open -t localhost:"${QUTE_COUNT:-8080}" >>"$QUTE_FIFO"
