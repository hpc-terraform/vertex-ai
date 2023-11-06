#!/bin/bash
# File: check-load-and-gpu.sh
# Location: /usr/local/bin/check-load-and-gpu.sh

# Load average for the past 1 minute
LOAD=$(uptime | awk -F 'load average:' '{ print $2 }' | cut -d, -f1 | awk '{ print $1}')

# Threshold below which we consider shutting down for load average
LOAD_THRESHOLD=0.3

# Threshold below which we consider shutting down for GPU utilization
GPU_THRESHOLD=5

# File to keep track of how long the load and GPU utilization have been low
STATE_FILE="/var/tmp/load-and-gpu-check.state"

# Get the current time
CURRENT_TIME=$(date +%s)

# Function to check if nvidia-smi is available
is_nvidia_smi_available() {
    which nvidia-smi > /dev/null 2>&1
}

# Initialize GPU_LOW_USAGE to an empty string
GPU_LOW_USAGE=""

# If nvidia-smi is available, check the GPU utilization
if is_nvidia_smi_available; then
    GPU_LOW_USAGE=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk -v threshold="$GPU_THRESHOLD" '$1 < threshold')
fi

# Check system load and, if applicable, GPU utilization
if (( $(echo "$LOAD < $LOAD_THRESHOLD" | bc) )) && ( [ -z "$GPU_LOW_USAGE" ] || [ ! -z "$GPU_LOW_USAGE" ] ); then
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
  # If the load is above the threshold or GPUs are not under the utilization threshold, remove the state file if it exists
  rm -f "$STATE_FILE"
fi
