#!/usr/bin/env bash

set +e

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

URL=$(echo "$QUTE_URL" | awk -F/ '{print $3}' | sed 's/www.//g')

echo "message-info 'Looking for password for $URL...'" >>"$QUTE_FIFO"

UUID=$(op item list --format=json | jq --arg url "$URL" -r '[.[] | {uuid, url: [.URLs[]?.u, .url][]?} | select(.uuid != null) | select(.url != null) | select(.url|test(".*\($url).*"))][.0].uuid') || UUID=""

if [ -z "$UUID" ] || [ "$UUID" == "null" ]; then
  echo "message-error 'No entry found for $URL'" >>"$QUTE_FIFO"
  TITLE=$(op item list --format=json | jq -r '.[].title' | rofi -dmenu -i) || TITLE=""
  if [ -n "$TITLE" ]; then
    UUID=$(op item list --format=json | jq --arg title "$TITLE" -r '[.[] | {uuid, title:.title}|select(.title|test("\($title)"))][.0].uuid') || UUID=""
  else
    UUID=""
  fi
fi

if [ -n "$UUID" ]; then
  ITEM=$(op item get "$UUID")

  PASSWORD=$(echo "$ITEM" | jq -r '.details.fields | .[] | select(.designation=="password") | .value')

  if [ -n "$PASSWORD" ]; then
    TITLE=$(echo "$ITEM" | jq -r '.title')
    USERNAME=$(echo "$ITEM" | jq -r '.details.fields | .[] | select(.designation=="username") | .value')

    printjs() {
      js | sed 's,//.*$,,' | tr '\n' ' '
    }
    echo "jseval -q $(printjs)" >>"$QUTE_FIFO"

    otp=$(echo "$ITEM" | op item get --otp "$UUID") || otp=""
    if [ -n "$otp" ]; then
      # TODO: Refactor to use wl-copy instead
      echo "$otp" | xclip -in -selection clipboard
      echo "message-info 'Pasted one time password for $TITLE to clipboard'" >>"$QUTE_FIFO"
    fi
  else
    echo "message-error 'No password found for $URL'" >>"$QUTE_FIFO"
  fi
else
  echo "message-error 'Entry not found for $UUID'" >>"$QUTE_FIFO"
fi
