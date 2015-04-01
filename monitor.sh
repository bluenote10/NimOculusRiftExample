#!/bin/bash
while true; do
  change=$(inotifywait -r -e close_write,moved_to,create,modify . 2> /dev/null) 
  sleep 0.3
  clear
  echo "changed: $change"
  ./build.sh
done
