#!/bin/bash
# Define the network interface name
INTERFACE="wlan0"

# Define the duration of the monitoring in seconds
DURATION=10

# Define the conversion factor from bytes to kilobytes
KB_FACTOR=1024

# Define the conversion factor from bytes to megabytes
MB_FACTOR=$((1024 * 1024))

# Get the initial values of received and transmitted bytes
RX_BYTES_1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX_BYTES_1=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

# Wait for the duration
sleep $DURATION

# Get the final values of received and transmitted bytes
RX_BYTES_2=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX_BYTES_2=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

# Calculate the difference of received and transmitted bytes
RX_BYTES_DIFF=$((RX_BYTES_2 - RX_BYTES_1))
TX_BYTES_DIFF=$((TX_BYTES_2 - TX_BYTES_1))

# Convert the difference to kilobytes or megabytes depending on the size
if [ $RX_BYTES_DIFF -lt $MB_FACTOR ]; then
  RX_DATA=$(echo "scale=2; $RX_BYTES_DIFF / $KB_FACTOR" | bc)
  RX_UNIT="KB"
else
  RX_DATA=$(echo "scale=2; $RX_BYTES_DIFF / $MB_FACTOR" | bc)
  RX_UNIT="MB"
fi

if [ $TX_BYTES_DIFF -lt $MB_FACTOR ]; then
  TX_DATA=$(echo "scale=2; $TX_BYTES_DIFF / $KB_FACTOR" | bc)
  TX_UNIT="KB"
else
  TX_DATA=$(echo "scale=2; $TX_BYTES_DIFF / $MB_FACTOR" | bc)
  TX_UNIT="MB"
fi

# Display the total data received and transmitted
echo "Total data received: $RX_DATA $RX_UNIT"
echo "Total data transmitted: $TX_DATA $TX_UNIT"

# Bonus Question: Calculate and display the current network speed
RX_SPEED=$(echo "scale=2; $RX_DATA / $DURATION" | bc)
TX_SPEED=$(echo "scale=2; $TX_DATA / $DURATION" | bc)
echo "Current download speed: $RX_SPEED $RX_UNIT/s"
echo "Current upload speed: $TX_SPEED $TX_UNIT/s"
