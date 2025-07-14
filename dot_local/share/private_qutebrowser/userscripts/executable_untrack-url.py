#!/bin/python
import subprocess
import random
import sys
import os

DEST_DOMAINS = {
  "nitter": [
    "nitter.net",
    "nitter.42l.fr",
    "nitter.pussthecat.org",
    "nitter.nixnet.services",
    "nitter.fdn.fr",
    "nitter.1d4.us",
    "nitter.kavin.rocks",
    "nitter.vxempire.xyz",
    "nitter.unixfox.eu",
    "nitter.domain.glass",
    "nitter.eu",
    "nitter.ethibox.fr",
    "nitter.namazso.eu",
    "nitter.mailstation.de",
    "nitter.actionsack.com",
    "nitter.cattube.org",
    "nitter.40two.app",
    "nitter.skrep.in",
    "nitter.hu",
    "nitter.database.red",
    "nitter.exonip.de",
    "nitter.dark.fail",
    "nitter.moomoo.me",
    "nitter.ortion.xyz",
  ],
  "invidious": [
    "yewtu.be",
    "invidious.snopyta.org",
    "invidious.kavin.rocks",
    "invidious.silkky.cloud",
    "invidious.048596.xyz",
    "invidious.exonip.de"
    "ytprivate.com",
  ],
  "teddit": [
    "teddit.net",
    "teddit.ggc-project.de",
    "teddit.kavin.rocks",
    "teddit.zaggy.nl",
    "teddit.namazso.eu",
    "teddit.nautolan.racing",
    "teddit.tinfoil-hat.net",
    "teddit.domain.glass",
    "snoo.ioens.is"
  ],
  "bibliogram": [
    "bibliogram.art",
    "bibliogram.snopyta.org",
    "bibliogram.pussthecat.org",
    "bibliogram.nixnet.services",
    "bibliogram.ethibox.fr",
    "insta.trom.tf",
    "bibliogram.hamster.dance",
    "bib.actionsack.com",
  ],
  "openstreetmap": [
    "www.openstreetmap.org",
  ]
}

SRC_DOMAINS = {
  "youtube": [
    "www.youtube.com",
    "m.youtube.com",
    "youtube.com",
    "youtu.be",
  ],
  "twitter" : [
    "mobile.twitter.com",
    "twitter.com",
  ],
  "instagram": [
    "www.instagram.com",
    "instagram.com",
  ],
  "reddit": [
    "www.reddit.com",
    "reddit.com",
  ],
  "googlemaps": [
    "maps.google.com",
  ]
}

SRC_TO_DEST = {
  "googlemaps": "openstreetmaps",
  "instagram": "bibliogram",
  "reddit": "teddit",
  "twitter": "nitter",
  "youtube": "invidious",
}

DEST_TO_SRC = {
  dest: src for src,dest in SRC_TO_DEST.items()
}

WOFI_CMD="wofi -dmenu -p 'Pick up a instance' -location 2"
DMENU_CMD="dmenu"

def src2dest(src):
  return SRC_TO_DEST[src]

def dest2src(dest):
  return DEST_TO_SRC[dest]

def get_dest_type(url):
  for src in SRC_TO_DEST:
    for domain in SRC_DOMAINS[src]:
      if domain in url:
        return src2dest(src)
  return ""

def get_untracked_url(url, dest_domain, dest_type):
  src_type = dest2src(dest_type)
  src_domains = SRC_DOMAINS[src_type]
  for domain in src_domains:
    if domain in url:
      return url.replace(domain, dest_domain)
  return ""

def get_dest_instances(dest_type):
  return DEST_DOMAINS[dest_type]

def pick_instance_from_user_selection(instances, cmd_menu):
  text = "\n".join(instances)
  cmd = f'echo -e "{text}" | {cmd_menu}'
  return subprocess.getoutput(cmd)

def pick_default_instance(instances):
  return instances[0]

def pick_random_instance(instances):
  return random.choices(instances)[0]

def pick_instance(instances, choice, cmd):
  if (choice == "user"):
    return pick_instance_from_user_selection(instances, cmd)
  if (choice == "random"):
    return pick_random_instance(instances)
  return pick_default_instance(instances)

def main(args):
  url = ""
  choice = "default"
  qute_command = "open"
  cmd = WOFI_CMD

  while (len(args) > 0):
    v = args[0]
    args.pop(0)
    if v == "-o":
      qute_command = "open"
    elif v == "-O":
      qute_command = "open -t"
    elif v == "-y":
      qute_command = "yank"
    elif v == "-Y":
      qute_command = "yank-primary"
    elif v == "-r":
      choice = "random"
    elif v == "-p":
      choice = "user"
    elif v == "-d":
      choice = "user"
      cmd = DMENU_CMD
    elif v == "-R":
      choice = "user"
      cmd = WOFI_CMD
    else:
      url = v

  # validate stuff
  if (url == ""):
    exit(1)
  dest_type = get_dest_type(url)
  if (dest_type == ""):
    exit(1)

  instances = get_dest_instances(dest_type)
  instance = pick_instance(instances, choice, cmd)
  untracked_url = get_untracked_url(url, instance, dest_type)

  QUTE_FIFO = os.environ['QUTE_FIFO']
  with open(QUTE_FIFO, 'a') as qute_fifo:
    qute_command = f"{qute_command} {untracked_url}"
    qute_fifo.write(qute_command)

args = sys.argv
args.pop(0) # first arg is the script's file name
main(args)

# TODO: Look into automatically redirecting to websites that don't track, by using something like this:
# https://github.com/qutebrowser/qutebrowser/discussions/6555#discussioncomment-6784618
# from qutebrowser.api import interceptor
#
# def redirect(info: interceptor.Request, domain, new_domain):
#     if info.request_url.host() == domain:
#         new_url = info.request_url
#         new_url.setHost(new_domain)
#         try:
#             info.redirect(new_url)
#         except interceptor.RedirectFailedException:
#             pass
#
#
# def intercept(info: interceptor.Request):
#     redirect(info, "youtube.com", "yewtu.be")
#     redirect(info, "www.youtube.com", "yewtu.be")
#     
#     redirect(info, "twitter.com", "nitter.it")
#     redirect(info, "www.twitter.com", "nitter.it")
#
# interceptor.register(intercept)
