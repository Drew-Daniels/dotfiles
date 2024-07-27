#!/usr/bin/env bash

# Get my current Public IP Address
IP=$(curl -s checkip.amazonaws.com)
# IP=255.255.255.255
NAME="$VPN_DOMAIN_NAME."
TYPE=A

if [[ ! $IP =~ ^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$ ]]; then

  exit 1

fi

# Get the current Public IP Address mapped to my registered domain and save this to a file
aws route53 list-resource-record-sets --hosted-zone-id Z04722771N10EI4U5OAF0 | jq -r --arg NAME "$NAME" --arg TYPE $TYPE '.ResourceRecordSets[] | select (.Name == $NAME) | select (.Type == $TYPE) | .ResourceRecords[0].Value' >/tmp/current_route53_value

# Check if my current Public IP Address matches the IP Address for my registered domain and if it does - exit
if grep -Fxq "$IP" /tmp/current_route53_value; then
  echo "IP Has Not Changed, Exiting"
  exit 1
fi

# Otherwise, update the DNS record in AWS
cat >/tmp/route53_changes.json <<EOF

{
  "Comment": "Update DNS",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "$NAME",
        "Type": "$TYPE",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "$IP"
          }
        ]
      }
    }
  ]
}

EOF

aws route53 change-resource-record-sets --hosted-zone-id Z04722771N10EI4U5OAF0 --change-batch file:///tmp/route53_changes.json >/dev/null
