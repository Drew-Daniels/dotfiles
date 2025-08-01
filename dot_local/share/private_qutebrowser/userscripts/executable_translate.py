#! /usr/bin/env python3

# TODO: Re-write this script in nodejs so I can use fetch API instead of needing 'requests' python module installed globally

import os
import sys
import urllib.parse
import requests
import json
import argparse

def js(message):
    return f"""
    (function() {{
        var box = document.createElement('div');
        box.style.position = 'fixed';
        box.style.bottom = '10px';
        box.style.right = '10px';
        box.style.backgroundColor = 'white';
        box.style.color = 'black';
        box.style.borderRadius = '8px';
        box.style.padding = '10px';
        box.style.boxShadow = '0 2px 10px rgba(0,0,0,0.2)';
        box.style.zIndex = '10000';
        box.innerText = decodeURIComponent("{message}");
        document.body.appendChild(box);

        function removeBox(event) {{
            if (!box.contains(event.target)) {{
                box.remove();
                document.removeEventListener('click', removeBox);
            }}
        }}
        document.addEventListener('click', removeBox);
    }})();
    """

def translate_google(text, target_lang):
    encoded_text = urllib.parse.quote(text)
    response = requests.get(f"https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl={target_lang}&dt=t&q={encoded_text}")
    response_json = json.loads(response.text)
    translated_text = ""
    for i in response_json[0]:
        translated_text += i[0]
    return translated_text

def translate_libretranslate(text, url, key, target_lang):
    response = requests.post(f"{url}/translate", data={
        'q': text,
        'source': 'auto',
        'target': target_lang,
        'api_key': key
    })
    return response.json()['translatedText']

def main():
    parser = argparse.ArgumentParser(description='Translate text using different providers.')
    parser.add_argument('--provider', choices=['google', 'libretranslate'], required=False, default='google', help='Translation provider to use')
    parser.add_argument('--libretranslate_url', required=False, default='https://libretranslate.com', help='URL for LibreTranslate API')
    parser.add_argument('--libretranslate_key', required=False, default='', help='API key for LibreTranslate')
    parser.add_argument('--target_lang', required=False, default='en', help='Target language for translation')
    parser.add_argument('--url', action='store_true', help='Translate the current URL instead of selected text')
    args = parser.parse_args()

    qute_fifo = os.getenv('QUTE_FIFO')
    if not qute_fifo:
        sys.stderr.write(f"Error: {sys.argv[0]} can not be run as a standalone script.\n")
        sys.stderr.write("It is a qutebrowser userscript. In order to use it, call it using 'spawn --userscript' as described in qute://help/userscripts.html\n")
        sys.exit(1)

    if args.url:
        current_url = urllib.parse.quote(os.getenv('QUTE_URL', ''))
        translated_url = f"https://translate.google.com/translate?sl=auto&tl={args.target_lang}&u={urllib.parse.quote(current_url)}"
        with open(qute_fifo, 'a') as fifo:
            fifo.write(f"open -t {translated_url}\n")
    else:
        text = os.getenv('QUTE_SELECTED_TEXT', '')

        if args.provider == 'google':
            translated_text = translate_google(text, args.target_lang)
        elif args.provider == 'libretranslate':
            translated_text = translate_libretranslate(text, args.libretranslate_url, args.libretranslate_key, args.target_lang)

        js_code = js(urllib.parse.quote(translated_text)).replace('\n', ' ')

        with open(qute_fifo, 'a') as fifo:
            fifo.write(f"jseval -q {js_code}\n")

if __name__ == "__main__":
    main()
