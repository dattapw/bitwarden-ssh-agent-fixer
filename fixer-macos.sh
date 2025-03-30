#!/bin/bash

# Script to reset SSH agents, clean up SSH_AUTH_SOCK, and restart Bitwarden
# For macOS systems

echo "Starting SSH and Bitwarden reset process..."

# Kill all running SSH agents
echo "Killing all SSH agents..."
pkill -f ssh-agent
if [ $? -eq 0 ]; then
    echo "SSH agents terminated successfully."
else
    echo "No running SSH agents found."
fi

# Delete the SSH_AUTH_SOCK file if it exists
if [ -n "$SSH_AUTH_SOCK" ] && [ -e "$SSH_AUTH_SOCK" ]; then
    echo "Removing SSH_AUTH_SOCK file: $SSH_AUTH_SOCK"
    rm -f "$SSH_AUTH_SOCK"
    echo "SSH_AUTH_SOCK file removed."
else
    echo "No SSH_AUTH_SOCK file found or variable not set."
fi

# Close Bitwarden if it's running
echo "Closing Bitwarden..."
osascript -e 'tell application "Bitwarden" to quit' &>/dev/null
if [ $? -eq 0 ]; then
    echo "Bitwarden closed successfully."
else
    echo "Bitwarden was not running or failed to close. Proceeding anyway."
fi

# Wait a moment to ensure everything has closed properly
echo "Waiting for processes to terminate..."
sleep 2

# Relaunch Bitwarden
echo "Relaunching Bitwarden..."
open -a Bitwarden
if [ $? -eq 0 ]; then
    echo "Bitwarden launched successfully."
else
    echo "Failed to launch Bitwarden. Please start it manually."
fi

# Wait a moment for Bitwarden to fully initialize
echo "Waiting for Bitwarden to initialize..."
sleep 5

# Check if Bitwarden SSH agent is working properly
echo "Checking Bitwarden SSH agent status..."

# Check if SSH_AUTH_SOCK exists after Bitwarden restart
if [ -n "$SSH_AUTH_SOCK" ] && [ -e "$SSH_AUTH_SOCK" ]; then
    echo "SSH_AUTH_SOCK exists: $SSH_AUTH_SOCK"
    
    # Check if the socket is listening
    if [ -S "$SSH_AUTH_SOCK" ]; then
        echo "Socket is available and listening."
        
        # Test if the SSH agent is responding
        ssh-add -l &>/dev/null
        if [ $? -eq 0 ] || [ $? -eq 1 ]; then
            # Exit code 0 means keys found, 1 means no keys but agent working
            echo "SSH agent is responding correctly."
        else
            echo "WARNING: SSH agent at $SSH_AUTH_SOCK is not responding properly."
        fi
    else
        echo "WARNING: $SSH_AUTH_SOCK exists but is not a valid socket."
    fi
else
    echo "WARNING: SSH_AUTH_SOCK is not set or the socket doesn't exist after Bitwarden restart."
    echo "You may need to check Bitwarden's SSH agent settings."
fi

echo "Reset process complete!"
