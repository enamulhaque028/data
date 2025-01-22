#!/bin/bash

# Colors for text styling
NC='\033[0m'         # No Color
BOLD='\033[1m'       # Bold
RED='\033[0;31m'     # Red
GREEN='\033[0;32m'   # Green
YELLOW='\033[1;33m'  # Yellow
BLUE='\033[0;34m'    # Blue
CYAN='\033[0;36m'    # Cyan
MAGENTA='\033[0;35m' # Magenta
WHITE='\033[1;37m'   # White

echo -e "${CYAN}------------------------------------------------------------------------------"
echo -e "${MAGENTA}${BOLD}Script:${NC} generate_assets.sh"
echo -e "${MAGENTA}${BOLD}Created by:${NC} MD ENAMUL HAQUE"
echo -e "${MAGENTA}${BOLD}Description:${NC}"
echo -e "This script automates the generation of a Dart file containing constants for"
echo -e "asset paths. It scans the specified assets directory, identifies all folders,"
echo -e "and generates a Dart class for each folder."
echo -e ""
echo -e "${YELLOW}${BOLD}Features:${NC}"
echo -e "- Generates a singleton Dart class for each asset folder."
echo -e "- Supports nested folder structures and multiple asset types."
echo -e "${CYAN}------------------------------------------------------------------------------"
echo -e "${GREEN}${BOLD}Usage:${NC}"
echo -e "1. Grant execute permissions: ${BOLD}chmod +x ./generate_assets.sh${NC}"
echo -e "2. Run the script: ${BOLD}./generate_assets.sh${NC}"
echo -e "3. Follow the prompts to specify the assets folder and output folder."
echo -e "${CYAN}------------------------------------------------------------------------------${NC}"
echo -e ""

# Prompt for assets folder
echo -e "${YELLOW}${BOLD}Enter the path to the assets folder (e.g., assets):${NC}"
read -p "> " assets_folder

# Check if assets folder exists
if [ ! -d "$assets_folder" ]; then
  echo -e "${RED}Error: The assets folder does not exist. Please check the path and try again.${NC}"
  exit 1
fi

# Prompt for output folder
echo -e "${YELLOW}${BOLD}Enter the path to the output folder:${NC}"
read -p "> " output_folder

# Check if output folder exists
if [ ! -d "$output_folder" ]; then
  echo -e "${BLUE}Info: The output folder does not exist. Creating it now...${NC}"
  mkdir -p "$output_folder"
fi

# Generate the Dart file path
dart_file="$output_folder/assets.dart"

# Write the Dart file header
echo -e "${CYAN}Generating Dart file header...${NC}"
echo "// Generated file. Do not edit manually." > "$dart_file"
echo "// This file contains constants for asset paths." >> "$dart_file"
echo "" >> "$dart_file"

# Find all subfolders in the assets folder (excluding the root assets folder)
folders=$(find "$assets_folder" -mindepth 1 -type d)

# Function to convert a string to UpperCamelCase
to_upper_camel_case() {
  echo "$1" | sed -E 's/[^a-zA-Z0-9]+/ /g' | awk '{for (i=1; i<=NF; i++) $i = toupper(substr($i,1,1)) tolower(substr($i,2))}1' | sed -E 's/ //g'
}

# Function to convert a string to lowerCamelCase
to_lower_camel_case() {
  echo "$1" | sed -E 's/([a-z0-9])([A-Z])/\1_\L\2/g' | sed -E 's/[^a-zA-Z0-9]+/ /g' | awk '{for (i=1; i<=NF; i++) $i = (i == 1 ? tolower($i) : toupper(substr($i,1,1)) substr($i,2))}1' | sed -E 's/ //g'
}

# Iterate over each folder
for folder in $folders; do
  # Get the folder name without the full path
  folder_name=$(basename "$folder")

  # Skip folders that start with a dot
  if [[ "$folder_name" == .* ]]; then
    continue
  fi

  # Convert folder name to UpperCamelCase and append 'Assets'
  class_name="$(to_upper_camel_case "$folder_name")Assets"

  # Add the class definition to the Dart file
  echo "class $class_name {" >> "$dart_file"
  echo "  const $class_name._();" >> "$dart_file"
  echo "" >> "$dart_file"

  # Find all files in the current folder, excluding hidden files
  find "$folder" -maxdepth 1 -type f ! -name ".*" | while read -r file; do
    # Strip the assets folder prefix and keep the relative path
    relative_path=${file#"$assets_folder/"}
    # Extract the base name of the file
    base_name=$(basename "$relative_path" | sed -E 's/\.[a-zA-Z0-9]+$//')
    # Convert file name to lowerCamelCase
    variable_name=$(to_lower_camel_case "$base_name")
    # Add an entry to the Dart file
    echo "  static const String $variable_name = '$assets_folder/$relative_path';" >> "$dart_file"
  done

  # Close the class
  echo "}" >> "$dart_file"
  echo "" >> "$dart_file"
done

echo -e "${GREEN}${BOLD}Dart file created successfully at $dart_file${NC}"
