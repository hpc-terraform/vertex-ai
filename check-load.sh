#!/bin/bash
# File: check-load.sh
# Location: /usr/local/bin/check-load.sh

# Load average for the past 1 minute
LOAD=$(uptime | awk -F 'load average:' '{ print $2 }' | cut -d, -f1 | awk '{ print $1}')

# Threshold below which we consider shutting down
THRESHOLD=0.3

# File to keep track of how long the load has been low
STATE_FILE="/var/tmp/loadcheck.state"

# Get the current time
CURRENT_TIME=$(date +%s)

if (( $(echo "$LOAD < $THRESHOLD" | bc) )); then
  if [ -f "$STATE_FILE" ]; then
    # If the state file exists, read the time from the file
    START_TIME=$(cat "$STATE_FILE")
    ELAPSED_TIME=$(($CURRENT_TIME - $START_TIME))
    
    # 30 minutes in seconds
    THIRTY_MINUTES=1800

    if [ $ELAPSED_TIME -ge $THIRTY_MINUTES ]; then
      # If the load has been low for 30 minutes or more, shut down
      rm -f "$STATE_FILE"
      /sbin/shutdown now "Shutting down due to low load for 30+ minutes."
    fi
  else
    # If the state file doesn't exist, create it with the current time
    echo "$CURRENT_TIME" > "$STATE_FILE"
  fi
else
  # If the load is above the threshold, remove the state file if it exists
  rm -f "$STATE_FILE"
fi
