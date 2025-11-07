#!/bin/bash
# Formats all .lua files recursively using stylua

# Exit if any command fails
set -e

# Check if stylua is installed
if ! command -v stylua &> /dev/null; then
  echo "Error: stylua is not installed. Install it first."
  exit 1
fi

# Format all Lua files
echo "Formatting all Lua files..."
find . -type f -name "*.lua" -exec stylua {} \;

echo "✅ Formatting complete!"

