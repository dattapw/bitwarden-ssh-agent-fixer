# Bitwarden SSH Agent Reset Script for MacOS

A utility script for macOS that resets SSH agents, cleans up SSH socket files, and restarts Bitwarden with SSH agent verification.

## Overview

This script solves common issues with Bitwarden's SSH agent integration on macOS by performing a complete reset of the SSH environment and restarting Bitwarden properly. It handles:

- Terminating all running SSH agents
- Cleaning up the SSH_AUTH_SOCK file
- Properly closing and relaunching Bitwarden
- Verifying that the Bitwarden SSH agent is functioning correctly

## Requirements

- macOS
- Bitwarden Desktop application installed
- Bash shell

## Installation

1. Download the script to your preferred location:

```bash
curl -o reset-ssh-bitwarden.sh
```

2. Make the script executable:

```bash
chmod +x reset-ssh-bitwarden.sh
```

## Usage

Simply run the script from Terminal:

```bash
./reset-ssh-bitwarden.sh
```

For convenience, you can add it to your PATH or create an alias in your shell profile:

```bash
# Add to ~/.zshrc or ~/.bash_profile
alias bw-reset="~/path/to/reset-ssh-bitwarden.sh"
```

## How It Works

The script performs the following steps:

1. Kills all running SSH agent processes
2. Removes the SSH_AUTH_SOCK file if it exists
3. Gracefully closes Bitwarden using AppleScript
4. Waits for processes to terminate
5. Relaunches Bitwarden
6. Waits for Bitwarden to initialize
7. Verifies that the SSH agent socket exists and is functional
8. Tests the SSH agent's ability to respond to commands

## Troubleshooting

If the script reports issues with the SSH agent after restarting Bitwarden:

1. Ensure Bitwarden is configured to enable the SSH agent
2. Check that you have the latest version of Bitwarden Desktop
3. Verify your Bitwarden account has SSH keys configured
4. Try running the script again

If problems persist, check Bitwarden logs for more information:
- Mac: ~/Library/Logs/Bitwarden

## Common Issues

- **"SSH agent is not responding correctly"**: This might indicate that Bitwarden's SSH agent feature is not enabled in settings.
- **"SSH_AUTH_SOCK is not set"**: Bitwarden may not be configured to expose the SSH agent socket.

## License

This script is provided under the MIT License. Feel free to modify and distribute as needed.

## Changelog

- v1.0 (2025-03-30): Initial release
