#!/usr/bin/env bash

set +e

# TODO: Add a step to automatically submit login button after inputting username and password
# TODO: Also add another step that automatically inputs OTP password if there is a page asking for this
# TODO: Figure out why TS syntax highlights don't work for entire HEREDOC
# TODO: See if I can move JS code into a separate .js file and call it from this bash script, for easier testability, syntax highlighting
# TODO: Add handling for tidal login flow, where first page shows username input, next page password
# TODO: Create a keybinding for running :spawn --userscript 1pass.sh
# TODO: Figure out why this script doesn't work for ProtonMail login. Text appears to get entered but then gets cleared out.
# NOTE: Not using 1password session token flow because enabling 1Password CLI integration diables this functionality
# https://www.reddit.com/r/1Password/comments/15ec88z/comment/ju7fgbs/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

# JS field injection code from https://github.com/qutebrowser/qutebrowser/blob/main/misc/userscripts/password_fill
javascript_escape() {
  # print the first argument in an escaped way, such that it can safely
  # be used within javascripts double quotes
  # shellcheck disable=SC2001
  sed "s,[\\\\'\"\/],\\\\&,g" <<<"$1"
}

js() {
  cat <<JS
    function isVisible(elem) {
        var style = elem.ownerDocument.defaultView.getComputedStyle(elem, null);
        if (style.getPropertyValue("visibility") !== "visible" ||
            style.getPropertyValue("display") === "none" ||
            style.getPropertyValue("opacity") === "0") {
            return false;
        }
        return elem.offsetWidth > 0 && elem.offsetHeight > 0;
    };
    function hasPasswordField(form) {
        var inputs = form.getElementsByTagName("input");
        for (var j = 0; j < inputs.length; j++) {
            var input = inputs[j];
            if (input.type == "password") {
                return true;
            }
        }
        return false;
    };
    function loadData2Form (form) {
        var inputs = form.getElementsByTagName("input");
        for (var j = 0; j < inputs.length; j++) {
            var input = inputs[j];
            if (isVisible(input) && (input.type == "text" || input.type == "email")) {
                input.focus();
                input.value = "$(javascript_escape "${USERNAME}")";
                input.dispatchEvent(new Event('change'));
                input.blur();
            }
            if (input.type == "password") {
                input.focus();
                input.value = "$(javascript_escape "${PASSWORD}")";
                input.dispatchEvent(new Event('change'));
                input.blur();
            }
        }
    };
    var forms = document.getElementsByTagName("form");
    if("$(javascript_escape "${QUTE_URL}")" == window.location.href) {
        for (i = 0; i < forms.length; i++) {
            if (hasPasswordField(forms[i])) {
                loadData2Form(forms[i]);
            }
        }
    } else {
        alert("Secrets will not be inserted.\nUrl of this page and the one where the user script was started differ.");
    }
JS
}

# 1. Attempt to locate the 1Password entry based on URL
URL=$(echo "$QUTE_URL" | awk -F/ '{print $3}' | sed 's/www.//g')
echo "message-info 'Looking for password for $URL...'" >>"$QUTE_FIFO"
UUID=$(op item list --format=json | jq --arg URL "$URL" -r '.[] | select(.category == "LOGIN" and (.urls[]?.href | contains($URL))) | .id') || UUID=""

# 2. If no entry is found that matches the URL, ask the user to manually select the entry that should be used to login
if [ -z "$UUID" ] || [ "$UUID" == "null" ]; then
  echo "message-error 'No entry found for $URL'" >>"$QUTE_FIFO"
  TITLE=$(op item list --format=json | jq -r '.[].title' | wofi -dmenu -i) || TITLE=""
  if [ -n "$TITLE" ]; then
    UUID=$(op item list --format=json | jq --arg title "$TITLE" -r '[.[] | {uuid, title:.title}|select(.title|test("\($title)"))][.0].uuid') || UUID=""
  else
    UUID=""
  fi
fi

# 3. If an entry is either found/selected, autofill the username and password, and copy the OTP code to clipboard
if [ -n "$UUID" ]; then
  USERNAME_PASSWORD=$(op item get "$UUID" --fields=username,password --reveal)
  USERNAME=$(echo "$USERNAME_PASSWORD" | cut -d ',' -f1)
  PASSWORD=$(echo "$USERNAME_PASSWORD" | cut -d ',' -f2)

  if [ -n "$PASSWORD" ]; then
    printjs() {
      js | sed 's,//.*$,,' | tr '\n' ' '
    }
    echo "jseval -q $(printjs)" >>"$QUTE_FIFO"

    otp=$(op item get --otp "$UUID") || otp=""
    if [ -n "$otp" ]; then
      # TODO: Refactor to use wl-copy instead
      echo "$otp" | wl-copy
      echo "message-info 'Pasted one time password for $URL to clipboard'" >>"$QUTE_FIFO"
    fi
  else
    echo "message-error 'No password found for $URL'" >>"$QUTE_FIFO"
  fi
else
  echo "message-error 'Entry not found for $UUID'" >>"$QUTE_FIFO"
fi
