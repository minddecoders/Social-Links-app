#!/bin/bash

# Automated Project Backup Manager

SOURCE_DIR="$1"
BACKUP_DIR="$2"

# Validate arguments
if [[ -z "$SOURCE_DIR" || -z "$BACKUP_DIR" ]]; then
    echo "Usage: ./backup_manager.sh <source_directory> <backup_directory>"
    exit 1
fi

# Check source directory
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "ERROR: Source directory does not exist"
    exit 1
fi

# Resolve absolute paths
SOURCE_DIR=$(realpath "$SOURCE_DIR")
BACKUP_DIR=$(realpath -m "$BACKUP_DIR")

# Prevent backup directory from being inside source
case "$BACKUP_DIR/" in
    "$SOURCE_DIR/"*)
        echo "ERROR: Backup directory must be outside source directory"
        exit 1
        ;;
esac

# Create backup directory
mkdir -p "$BACKUP_DIR" || exit 1

# Generate timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
PROJECT_NAME=$(basename "$SOURCE_DIR")

BACKUP_FILE="${BACKUP_DIR}/${PROJECT_NAME}_${TIMESTAMP}.tar.gz"

echo "================================"
echo "       BACKUP STARTED"
echo "================================"

echo "Source: $SOURCE_DIR"
echo "Destination: $BACKUP_DIR"

# Create compressed backup
if tar \
    --exclude=".git" \
    --exclude=".env" \
    --exclude=".env.*" \
    -czf "$BACKUP_FILE" \
    -C "$(dirname "$SOURCE_DIR")" \
    "$PROJECT_NAME"; then

    echo "Backup created successfully"
else
    echo "ERROR: Backup creation failed"
    exit 1
fi

# Verify archive
if tar -tzf "$BACKUP_FILE" > /dev/null; then
    echo "Backup verification: PASSED"
else
    echo "ERROR: Backup verification failed"
    exit 1
fi

# Generate checksum
sha256sum "$BACKUP_FILE" > "${BACKUP_FILE}.sha256"

echo "Backup File: $BACKUP_FILE"
echo "Checksum File: ${BACKUP_FILE}.sha256"
echo "Backup Size: $(du -h "$BACKUP_FILE" | awk '{print $1}')"

echo "================================"
echo "       BACKUP COMPLETED"
echo "================================"
