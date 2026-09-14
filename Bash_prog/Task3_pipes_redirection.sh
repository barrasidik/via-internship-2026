#!/usr/bin/env bash
# -----------------------------------------------------------------
# @title        Task3_pipes_redirection.sh
# @author       Sidik Barra Mohammed Awal
# @index        4196524
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  Creates sample log data and uses pipes and text
#               processing commands to generate a summary report.
# @date         14/09/2026
# -----------------------------------------------------------------

# Display the correct way to run the script.
usage() {
  echo "Usage: $0"
  echo "  No arguments are required."
}

# Display help when requested.
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit 0
fi

# This script does not need any arguments.
if [[ $# -ne 0 ]]; then
  echo "Error: No arguments are required for this script." >&2
  usage
  exit 1
fi

LOG_FILE="system_logs.txt"
RESULTS="results.txt"
ERRORS="errors.log"

# Generate sample log data using a heredoc.
if cat > "$LOG_FILE" <<EOF
2026-09-11 09:01:10 INFO 192.168.1.10 User login successful
2026-09-11 09:01:25 INFO 192.168.1.15 File uploaded successfully
2026-09-11 09:01:40 ERROR 192.168.1.20 Connection timeout
2026-09-11 09:01:55 WARN 192.168.1.10 Disk usage above 80%
2026-09-11 09:02:10 INFO 192.168.1.10 User logout successful
2026-09-11 09:02:25 ERROR 192.168.1.20 Database error
2026-09-11 09:02:40 INFO 192.168.1.25 File downloaded successfully
2026-09-11 09:02:55 WARN 192.168.1.15 High memory usage
2026-09-11 09:03:10 INFO 192.168.1.10 User login successful
2026-09-11 09:03:25 ERROR 192.168.1.25 Permission denied
2026-09-11 09:03:40 INFO 192.168.1.15 File uploaded successfully
2026-09-11 09:03:55 WARN 192.168.1.10 High CPU usage
2026-09-11 09:04:10 INFO 192.168.1.20 User login successful
2026-09-11 09:04:25 ERROR 192.168.1.20 Service unavailable
2026-09-11 09:04:40 INFO 192.168.1.10 File downloaded successfully
2026-09-11 09:04:55 WARN 192.168.1.25 Disk usage above 80%
2026-09-11 09:05:10 INFO 192.168.1.15 User logout successful
2026-09-11 09:05:25 ERROR 192.168.1.10 Connection timeout
2026-09-11 09:05:40 INFO 192.168.1.10 Password changed
2026-09-11 09:05:55 WARN 192.168.1.20 High memory usage
2026-09-11 09:06:10 INFO 192.168.1.25 User login successful
2026-09-11 09:06:25 ERROR 192.168.1.25 Database error
2026-09-11 09:06:40 INFO 192.168.1.10 File uploaded successfully
2026-09-11 09:06:55 WARN 192.168.1.15 High CPU usage
2026-09-11 09:07:10 INFO 192.168.1.20 File downloaded successfully
2026-09-11 09:07:25 ERROR 192.168.1.20 Permission denied
2026-09-11 09:07:40 INFO 192.168.1.10 User login successful
2026-09-11 09:07:55 WARN 192.168.1.25 Memory usage above 80%
2026-09-11 09:08:10 INFO 192.168.1.15 User logout successful
2026-09-11 09:08:25 ERROR 192.168.1.10 Service unavailable
2026-09-11 09:08:40 INFO 192.168.1.20 Password changed
2026-09-11 09:08:55 WARN 192.168.1.10 Disk usage above 80%
2026-09-11 09:09:10 INFO 192.168.1.25 User login successful
2026-09-11 09:09:25 ERROR 192.168.1.25 Connection timeout
2026-09-11 09:09:40 INFO 192.168.1.10 File uploaded successfully
2026-09-11 09:09:55 WARN 192.168.1.15 High memory usage
2026-09-11 09:10:10 INFO 192.168.1.20 File downloaded successfully
2026-09-11 09:10:25 ERROR 192.168.1.20 Database error
2026-09-11 09:10:40 INFO 192.168.1.10 User login successful
2026-09-11 09:10:55 WARN 192.168.1.25 High CPU usage
2026-09-11 09:11:10 INFO 192.168.1.15 Password changed
2026-09-11 09:11:25 ERROR 192.168.1.10 Permission denied
2026-09-11 09:11:40 INFO 192.168.1.25 User logout successful
2026-09-11 09:11:55 WARN 192.168.1.20 Disk usage above 80%
2026-09-11 09:12:10 INFO 192.168.1.10 User login successful
2026-09-11 09:12:25 ERROR 192.168.1.25 Service unavailable
2026-09-11 09:12:40 INFO 192.168.1.20 File uploaded successfully
2026-09-11 09:12:55 WARN 192.168.1.15 Memory usage above 80%
2026-09-11 09:13:10 INFO 192.168.1.10 File downloaded successfully
2026-09-11 09:13:25 ERROR 192.168.1.20 Connection timeout
EOF
then
  echo "Sample log file created: $LOG_FILE"
else
echo "Error: Failed to create the sample log file." >&2
  exit 1
fi

# Start with empty output files.
if : > "$RESULTS" && : > "$ERRORS"; then
  echo "Output files prepared."
else
  echo "Error: Could not prepare the output files." >&2
  exit 1
fi

# Generate the requested report.
{
  echo "========== LOG REPORT =========="
  echo

  # 1. Count all log entries.
  echo "Total number of log lines:"
  if wc -l < "$LOG_FILE"; then
    :
  else
    echo "Error: Could not count the log lines."
    exit 1
  fi

  # 2. Count the different log levels.
  echo
  echo "Number of INFO lines:"
  if grep " INFO " "$LOG_FILE" | wc -l; then
    :
  else
    echo "Error: Could not count INFO lines."
    exit 1
  fi

  echo "Number of WARN lines:"
  if grep " WARN " "$LOG_FILE" | wc -l; then
    :
  else
    echo "Error: Could not count WARN lines."
    exit 1
  fi

  echo "Number of ERROR lines:"
  if grep " ERROR " "$LOG_FILE" | wc -l; then
    :
  else
    echo "Error: Could not count ERROR lines."
    exit 1
  fi

  # 3. Find the three most common IP addresses.
  echo
  echo "Top 3 most frequent IP addresses:"
  if awk '{print $4}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -3; then
    :
  else
    echo "Error: Could not calculate the top IP addresses."
    exit 1
  fi

  # 4. Display only ERROR entries.
  echo
  echo "All ERROR lines:"
  if grep " ERROR " "$LOG_FILE"; then
    :
  else
    echo "Error: Could not find ERROR lines."
    exit 1
  fi

} > "$RESULTS" 2> "$ERRORS"

# Check whether the report was generated successfully.
if [[ $? -eq 0 ]]; then
  echo "Report successfully saved to $RESULTS"
else
  echo "Error: Report generation failed. Check $ERRORS." >&2
  exit 1
fi

echo "Task 3 completed successfully."
exit 0