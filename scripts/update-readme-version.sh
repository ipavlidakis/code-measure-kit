#!/bin/bash

# Get the directory of the script itself
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Move one level up from the script directory to get the project root
PROJECT_ROOT="$SCRIPT_DIR/.."

# Define paths
TEMPLATES_DIR="$PROJECT_ROOT/Templates"
SOURCE_README="$TEMPLATES_DIR/README.md"
DESTINATION_README="$PROJECT_ROOT/README.md"

# Check if README.md exists in the Templates directory
if [[ ! -f "$SOURCE_README" ]]; then
  echo "Error: README.md not found in $TEMPLATES_DIR"
  exit 1
fi

# Remove existing README.md in the project root (if any)
if [[ -f "$DESTINATION_README" ]]; then
  rm "$DESTINATION_README"
  echo "Existing README.md in $PROJECT_ROOT deleted"
fi

# Copy README.md from Templates to the project root
cp "$SOURCE_README" "$DESTINATION_README"
echo "README.md copied from $TEMPLATES_DIR to $PROJECT_ROOT"

# Extract version from Package.swift located in the project root
VERSION=$(grep 'let version' "$PROJECT_ROOT/Package.swift" | sed -n 's/.*"\(.*\)"/\1/p')

# Update the README.md in the project root with the extracted version
sed -i '' "s/VERSION_PLACEHOLDER/$VERSION/g" "$DESTINATION_README"

echo "Updated README.md with version $VERSION"