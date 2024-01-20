#!/bin/bash

# Directory to search in
DIR="."

# Maximum total characters allowed
MAX_TOTAL_CHARS=20000

# Function to print a portion of a file
print_file_portion() {
    local file=$1
    local max_chars_per_file=$2
    echo "====================================="
    echo "File: $file"
    echo "====================================="
    head -c $max_chars_per_file "$file"
    echo -e "\n... (truncated)"
}

# Count the number of HTML, CSS, and JavaScript files
file_count=$(find $DIR -type f \( -name "*.html" -o -name "*.css" -o -name "*.js" \) | wc -l)

# Calculate the max characters per file
if [ $file_count -gt 0 ]; then
    max_chars_per_file=$((MAX_TOTAL_CHARS / file_count))
else
    echo "No target files found."
    exit 1
fi

# Export the function so that it's available to 'find'
export -f print_file_portion

# Use find to process each file
find $DIR -type f \( -name "*.html" -o -name "*.css" -o -name "*.js" \) -exec bash -c 'print_file_portion "$0" '"$max_chars_per_file"' ' {} \;
