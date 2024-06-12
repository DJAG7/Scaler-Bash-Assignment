#!/bin/bash

# Error Testing, Assign Directory

if [ -z "$1" ]; then
  echo "Please Provide a Directory"
  exit 1
fi

DIR=$1

if [ ! -d "$DIR" ]; then
  echo "Directory not found"
  exit 1
fi

#Directory Output 

echo "Directory provided: $DIR"


# Recursively Traversing Directory

declare -A filetypes


traverse_dir() {
  local dir="$1"
  local file
  while IFS= read -r -d '' file; do
    ext="${file##*.}"
    if [ "$file" == "$ext" ]; then

      ext="No extension found"

    fi

    (( filetypes["$ext"]++ ))
  done < <(find "$dir" -type f -print0)

}

traverse_dir "$DIR"


# Output for file type counts
echo "File type counts:"
for ext in "${!filetypes[@]}"; do
  echo "$ext: ${filetypes[$ext]}"
done
