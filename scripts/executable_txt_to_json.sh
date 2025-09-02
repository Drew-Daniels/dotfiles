#!/bin/bash

# Script created to transform a list of Arch Package Repository packages into a JSON string, where each
# package is a separate entry under a top level key called 'packages'

# Start the JSON string
json_output='{"packages": ['

# Read from standard input
while IFS= read -r line; do
  # Trim whitespace and skip empty lines
  package_name=$(echo "$line" | xargs)
  if [ -n "$package_name" ]; then
    json_output+="\"$package_name\", "
  fi
done

# Remove the trailing comma and space, if any
json_output=${json_output%, }

# Close the JSON array and object
json_output+=']}'

# Print the JSON output
echo "$json_output"
