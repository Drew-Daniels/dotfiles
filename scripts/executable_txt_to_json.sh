#!/bin/bash

# Script created to transform a list of Arch Package Repository packages into a JSON string, where each
# package is a separate entry under a top level key called 'packages'

# Check if the input file is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <input_file.txt>"
  exit 1
fi

input_file="$1"

# Check if the file exists
if [ ! -f "$input_file" ]; then
  echo "File not found: $input_file"
  exit 1
fi

# Start the JSON string
json_output='{"packages": ['

# Read the file line by line
while IFS= read -r line; do
  # Trim whitespace and skip empty lines
  package_name=$(echo "$line" | xargs)
  if [ -n "$package_name" ]; then
    json_output+="\"$package_name\", "
  fi
done <"$input_file"

# Remove the trailing comma and space, if any
json_output=${json_output%, }

# Close the JSON array and object
json_output+=']}'

# Print the JSON output
echo "$json_output"
