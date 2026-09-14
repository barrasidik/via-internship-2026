#!/usr/bin/env bash
# -----------------------------------------------------------------
# @title        Task2_permissions_sudo.sh
# @author       Sidik Barra Mohammed Awal
# @index        4196524
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  Displays file permissions, changes permissions using
#               numeric and symbolic chmod, and checks root privileges.
# @date         14/09/2026
# -----------------------------------------------------------------

# Show how to use the script.
usage() {
  echo "Usage: $0 <file-path>"
  echo "  <file-path>  file whose permissions will be checked and changed"
}

# Show help when requested.
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit 0
fi

# Check that exactly one argument was given.
if [[ $# -ne 1 ]]; then
  echo "Error: Please provide one file path." >&2
  usage
  exit 1
fi

FILE="$1"

# Check that the file exists.
if [[ ! -f "$FILE" ]]; then
  echo "Error: '$FILE' is not a valid file." >&2
  exit 1
fi

# Step 1: Display the current permissions.
echo "Current permissions for $FILE:"

if PERMISSIONS=$(stat -c "%A" "$FILE"); then
  echo "Symbolic: ${PERMISSIONS:1}"
else
  echo "Error: Could not get symbolic permissions." >&2
  exit 1
fi

if NUMBER=$(stat -c "%a" "$FILE"); then
  echo "Numeric: $NUMBER"
else
  echo "Error: Could not get numeric permissions." >&2
  exit 1
fi

# Step 2: Change permissions using numeric chmod.
if chmod 644 "$FILE"; then
  echo "Numeric permission change successful: chmod 644"
else
  echo "Error: Could not change permissions using numeric chmod." >&2
  exit 1
fi

# Step 3: Change permissions using symbolic chmod.
if chmod u+x "$FILE"; then
  echo "Symbolic permission change successful: chmod u+x"
else
  echo "Error: Could not change permissions using symbolic chmod." >&2
  exit 1
fi

# Step 4: Check if the script is running as root.
if [[ "$(id -u)" -eq 0 ]]; then
  echo "Root privileges detected."

  # Try changing the owner and group of the file.
  if chown root:root "$FILE"; then
    echo "File ownership changed successfully."
  else
    echo "Error: Could not change file ownership." >&2
    exit 1
  fi
else
  echo "Root privileges not detected."
  echo "Skipping chown because root privileges are required."
fi

# Step 5: Display the permissions after the changes.
echo "Permissions after changes:"

if PERMISSIONS=$(stat -c "%A" "$FILE"); then
  echo "Symbolic: ${PERMISSIONS:1}"
else
  echo "Error: Could not get updated symbolic permissions." >&2
  exit 1
fi

if NUMBER=$(stat -c "%a" "$FILE"); then
  echo "Numeric: $NUMBER"
else
  echo "Error: Could not get updated numeric permissions." >&2
  exit 1
fi

echo "Task 2 completed successfully."
exit 0