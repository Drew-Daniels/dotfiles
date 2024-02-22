#!/usr/bin/env bash

auth_pid=6544
api_pid=6558
admin_pid=6557
pt_pid=6560
embedded_pid=6545
ui_components_pid=6540
mobile_pid=6563
ops_tools_pid=6526
auth_client_pid=6511
api_client_pid=6554
patient_pid=6559

CWD=$(pwd)

if [[ $CWD == *"keet-auth"* ]]; then
  PID=$auth_pid
elif [[ $CWD == *"keet-api"* ]]; then
  PID=$api_pid
elif [[ $CWD == *"keet-admin"* ]]; then
  PID=$admin_pid
elif [[ $CWD == *"keet-umi"* ]]; then
  PID=$pt_pid
elif [[ $CWD == *"keet-embedded"* ]]; then
  PID=$embedded_pid
elif [[ $CWD == *"ui-components"* ]]; then
  PID=$ui_components_pid
elif [[ $CWD == *"keet-mobile"* ]]; then
  PID=$mobile_pid
elif [[ $CWD == *"ops-tools"* ]]; then
  PID=$ops_tools_pid
elif [[ $CWD == *"keet-auth-client"* ]]; then
  PID=$auth_client_pid
elif [[ $CWD == *"keet-api-client"* ]]; then
  PID=$api_client_pid
elif [[ $CWD == *"keet-patient"* ]]; then
  PID=$patient_pid
else
  echo "Unknown project"
  exit 1
fi

jq --null-input --arg yaml "$(<.gitlab-ci.yml)" '.content=$yaml' \
      | curl "https://gitlab.webpt.com/api/v4/projects/$PID/ci/lint" \
      --header 'Content-Type: application/json' \
      --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
      --data @- | jq ".errors"
