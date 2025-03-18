#!/usr/bin/env bash

# Updates packages that have to be manually updated outside of 'apt'
# TODO: Add check to see if there is a later version available, and only install if it is differerent version from current install
# TODO: Suppress curl output
#╭──────────────────────────────────────────────────────────────────────────────╮
#│                                    awscli                                    │
#│https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html │
#╰──────────────────────────────────────────────────────────────────────────────╯
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

# cleanup
rm awscliv2.zip
rm -rf aws
