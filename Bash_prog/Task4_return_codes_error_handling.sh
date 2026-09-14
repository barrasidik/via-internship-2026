#!/usr/bin/env bash
# -----------------------------------------------------------------
# @title        Task4_return_codes_error_handling.sh
# @author       Sidik Barra Mohammed Awal
# @index        4196524
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  Checks system conditions and handles command return
#               codes using specific exit codes and a cleanup trap.
# @date         14/09/2026
#
# Exit codes:
#   0 = all checks passed
#   1 = missing required argument
#   2 = host unreachable
#   3 = insufficient disk space
#   4 = required file not found or not readable
#   5 = required command not found
# -----------------------------------------------------------------

TEMP_FILE="task4_check.txt"

# Delete the temporary file when the script finishes or is interrupted.
remove_temp() {
  rm -f "$TEMP_FILE"
}

trap remove_temp EXIT INT TERM

# Show how to use the script.
usage() {
  echo "Usage: $0 <hostname>"
  echo "  <hostname>  hostname to test for connectivity"
}

# Display help if requested.
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit 0
fi

# A hostname must be supplied.
if [[ $# -ne 1 ]]; then
  echo "Error: Please provide a hostname." >&2
  usage
  exit 1
fi

HOSTNAME="$1"

# Function for checking command results.
check_status() {
  RESULT=$?
  DESCRIPTION="$1"
  CODE="$2"

  if [[ $RESULT -eq 0 ]]; then
    echo "PASS: $DESCRIPTION"
  else
    echo "FAIL: $DESCRIPTION" >&2
    exit "$CODE"
  fi
}

# Check 1: Make sure the ping program is available.
command -v ping > /dev/null 2>&1
check_status "The ping command is installed." 5

# Check 2: Test whether the supplied host can be reached.
ping -c 1 -W 2 "$HOSTNAME" > /dev/null 2>&1
check_status "The host '$HOSTNAME' is reachable." 2

# Check 3: Check the available disk space on the root filesystem.
if df / > "$TEMP_FILE"; then
  AVAILABLE=$(awk 'NR==2 {print $4}' "$TEMP_FILE")

  if [[ "$AVAILABLE" -ge 1048576 ]]; then
    echo "PASS: There is enough free disk space."
  else
    echo "FAIL: There is not enough free disk space." >&2
    exit 3
  fi
else
  echo "FAIL: Could not check the available disk space." >&2
  exit 3
fi

# Check 4: Make sure the required file exists and is readable.
REQUIRED_FILE="/etc/hosts"

if [[ -f "$REQUIRED_FILE" && -r "$REQUIRED_FILE" ]]; then
  echo "PASS: $REQUIRED_FILE exists and is readable."
else
  echo "FAIL: $REQUIRED_FILE is missing or cannot be read." >&2
  exit 4
fi

echo
echo "All four checks passed."
exit 0