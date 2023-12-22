#!/bin/bash

SCRIPT_NAME="script.py"

PID=$(ps aux | grep $SCRIPT_NAME | grep -v "grep" | awk '{print $2}')

if [ -z "$PID" ]; then
    echo "Process not found."
else
    echo "Killing process with PID: $PID"
    sudo kill $PID
fi
