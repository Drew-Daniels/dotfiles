#!/usr/bin/env bash

curl "https://loripsum.net/api/${1-5}/plaintext" | tr -d \\n | pbcopy
