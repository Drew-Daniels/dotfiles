#!/usr/bin/env bash

IP=$(curl -s checkip.amazonaws.com)
NAME="$VPN_DOMAIN_NAME."
TYPE=A

if [[ ! $IP =~ ^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$ ]]; then

  exit 1

fi

aws route53 list-resource-record-sets --hosted-zone-id Z04722771N10EI4U5OAF0 | jq -r --arg NAME "$NAME" --arg TYPE $TYPE '.ResourceRecordSets[] | select (.Name == $NAME) | select (.Type == $TYPE) | .ResourceRecords[0].Value' >/tmp/current_route53_value

if grep -Fxq "$IP" /tmp/current_route53_value; then
  echo "IP Has Not Changed, Exiting"
  exit 1
fi

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
