#!/bin/bash

address=google.com
max_ping_time_ms=100
max_failures=3
count=0


while :
do
    ping_output=$(ping -c 1 -W 1 "$address" 2>/dev/null)

  if [[ $? -eq 0 ]]; then
    
    count=0
    time=$(echo "$ping_output" | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')
    
    
    if (( $(echo "$time > $max_ping_time_ms" | bc -l) )); then
      echo "Ping time to $address is over $max_ping_time_ms ms: $time ms"
    else
      echo "Ping successful: $time ms"
    fi
  else
    
    ((count++))
    echo "Ping to $address failed ($count/$max_failures)"
  fi

  
  if [[ $count -ge $max_failures ]]; then
    echo "Failed to ping $address for $max_failures consecutive attempts. Exiting."
    exit 1
  fi

  
  sleep 1
done
