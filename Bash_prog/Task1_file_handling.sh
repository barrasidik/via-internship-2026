#!/bin/bash
# ==============================================================================
# Task 1: File & Directory Handling in Bash
# VIA Internship 2026
# Description: Demonstrates creation, reading, appending, searching, archiving,
#              and deleting files and directories safely.
# ==============================================================================

# ANSI Color Codes for enhanced output readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RESET='\033[0m'

echo -e "${BLUE}====================================================${RESET}"
echo -e "${GREEN}       Task 1: File & Directory Handling Demo      ${RESET}"
echo -e "${BLUE}====================================================${RESET}\n"

WORK_DIR="./demo_workspace"

# 1. Directory Creation
echo -e "${YELLOW}[Step 1] Creating Working Directory structure...${RESET}"
mkdir -p "$WORK_DIR/documents" "$WORK_DIR/backup" "$WORK_DIR/logs"
echo "Created: $WORK_DIR/{documents, backup, logs}"

# 2. File Creation & Writing Content
echo -e "\n${YELLOW}[Step 2] Creating and writing text files...${RESET}"
cat << 'EOF' > "$WORK_DIR/documents/sample1.txt"
Welcome to VIA Internship 2026!
This is a demonstration of file handling in Bash.
Task 1 covers fundamental file operations.
EOF
echo "Written content to sample1.txt"

echo "Log entry: Task 1 initialized at $(date)" > "$WORK_DIR/logs/app.log"
echo "Written initial log entry to logs/app.log"

# 3. Appending to File
echo -e "\n${YELLOW}[Step 3] Appending content to an existing file...${RESET}"
echo "Appended log entry: Secondary process check completed." >> "$WORK_DIR/logs/app.log"
echo "Updated content of logs/app.log:"
cat "$WORK_DIR/logs/app.log"

# 4. Reading File Content with Line Numbers
echo -e "\n${YELLOW}[Step 4] Reading document with line numbers...${RESET}"
nl -ba "$WORK_DIR/documents/sample1.txt"

# 5. Copying & Moving Files
echo -e "\n${YELLOW}[Step 5] Copying and moving files...${RESET}"
cp "$WORK_DIR/documents/sample1.txt" "$WORK_DIR/documents/sample1_copy.txt"
echo "Copied sample1.txt -> sample1_copy.txt"

mv "$WORK_DIR/documents/sample1_copy.txt" "$WORK_DIR/backup/sample1_archived.txt"
echo "Moved sample1_copy.txt -> backup/sample1_archived.txt"

# 6. File Searching (find and grep)
echo -e "\n${YELLOW}[Step 6] Searching files and pattern matching...${RESET}"
echo "Finding all .txt files inside $WORK_DIR:"
find "$WORK_DIR" -type f -name "*.txt"

echo -e "\nSearching for keyword 'Internship' in files:"
grep -rn "Internship" "$WORK_DIR"

# 7. Archiving (tar & gzip)
echo -e "\n${YELLOW}[Step 7] Archiving directory into tar.gz...${RESET}"
tar -czf "$WORK_DIR/backup_archive.tar.gz" -C "$WORK_DIR" documents logs
echo "Created archive: $WORK_DIR/backup_archive.tar.gz"

# 8. Listing Directory Contents
echo -e "\n${YELLOW}[Step 8] Final Directory Tree View: ${RESET}"
ls -laR "$WORK_DIR"

# 9. Cleanup prompt/demonstration
echo -e "\n${YELLOW}[Step 9] Cleanup demonstration...${RESET}"
echo "Removing demo directory '$WORK_DIR'..."
rm -rf "$WORK_DIR"
echo -e "${GREEN}Task 1 completed successfully! Demo workspace cleaned up.${RESET}"
