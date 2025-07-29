#!/bin/bash

##----- Author : Syrder Baptichon
##----- Purpose : A tool to archive logs from thi CLI with the date and time
##----- Usage : ./log archive <log-directory>
##----- Project from roadmap.sh (https://roadmap.sh/projects/log-archive-tool)
##----- PS : Creates the archives in the "log-archives" folder in your user home directory or root directory if using sudo
##----- PS-bis : Might have to execute as "sudo" if you do not have read permissions to certain log files

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Check for arguments
[[ $# -eq 0 ]] && { echo "Usage: $0 <log-directory>"; echo "Example: $0 /var/log"; exit 1; }

LOG_DIR="$1"

# Validate log directory exists
[[ -d "$LOG_DIR" ]] || { echo "Error: Directory '$LOG_DIR' does not exist"; exit 1; }

# Check read permissions
[[ -r "$LOG_DIR" ]] || { echo "Error: No read permission for directory '$LOG_DIR'"; exit 1; }

# Archive directory
ARCHIVE_DIR="$HOME/log-archives"

# Generate timestamp for archive name
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_FILE="$ARCHIVE_DIR/logs_archive_$TIMESTAMP.tar.gz"

echo "Starting log archival process..."
echo "Source directory: $LOG_DIR"
echo "Archive will be created: $ARCHIVE_FILE"

# Find log files and create archive
LOG_FILES=$(find "$LOG_DIR" -maxdepth 1 -type f \( \
    -name "*.log" -o \
    -name "*.log.*" -o \
    -name "*.out" -o \
    -name "*.err" \
\) 2>/dev/null || true)

# Check if any log files were found
[[ -z "$LOG_FILES" ]] && { echo "No log files found in $LOG_DIR"; exit 0; }

# Check read permissions for each file
for file in $LOG_FILES; do
     [[ ! -r "$file" ]] && { echo "Error: No read permission for file '$file'. Aborting archive creation."; exit 1; }
done

# Count files
FILE_COUNT=$(echo "$LOG_FILES" | wc -l)
echo "Found $FILE_COUNT log files to archive"

# Create archive directory
mkdir -p "$ARCHIVE_DIR"

# Create the tar.gz archive
if tar -czf "$ARCHIVE_FILE" -C "$LOG_DIR" --exclude="archive" \
    $(find "$LOG_DIR" -maxdepth 1 -type f \( \
        -name "*.log" -o \
        -name "*.log.*" -o \
        -name "*.out" -o \
        -name "*.err" \
    \) -printf "%f\n" 2>/dev/null); then

    # Get archive size
    ARCHIVE_SIZE=$(stat -c%s "$ARCHIVE_FILE" 2>/dev/null || stat -f%z "$ARCHIVE_FILE" 2>/dev/null)
    SIZE_MB=$(echo "scale=2; $ARCHIVE_SIZE / 1024 / 1024" | bc 2>/dev/null || echo "unknown")

    echo "Archive created successfully!"
    echo "Archive: $ARCHIVE_FILE"
    echo "Size: ${SIZE_MB} MB"

    # Log the archival
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Archive created: $(basename "$ARCHIVE_FILE") (${SIZE_MB} MB, $FILE_COUNT files)" >> "$ARCHIVE_DIR/archive_log.txt"

else
    echo "Error: Failed to create archive"
    exit 1
fi
