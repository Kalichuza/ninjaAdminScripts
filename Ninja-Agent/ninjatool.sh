#!/bin/bash

# Parse command line options for different operations
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -DelTeamViewer) DEL_TEAMVIEWER=true ;;
        -Cleanup) CLEANUP=true ;;
        -Uninstall) UNINSTALL=true ;;
        -ShowError) SHOW_ERROR=true ;;
    esac
    shift
done

# Function to uninstall Ninja RMM Agent
uninstall_ninja() {
    echo "Starting Ninja RMM Agent uninstallation..."
    # Check if the Ninja RMM service is running and stop it
    if systemctl is-active --quiet ninja-agent.service; then
        systemctl stop ninja-agent.service
    fi

    # Disable the service to prevent it from starting on boot
    systemctl disable ninja-agent.service

    # Remove the service file if it exists
    if [ -f /etc/systemd/system/ninja-agent.service ]; then
        rm /etc/systemd/system/ninja-agent.service
        systemctl daemon-reload
    fi

    # Remove Ninja installation directory
    if [ -d /opt/ninja-agent ]; then
        rm -rf /opt/ninja-agent
    fi

    echo "Ninja RMM Agent uninstalled successfully."
}

# Function to clean up residual files
cleanup_files() {
    echo "Cleaning up residual files..."
    # Example: Remove logs and temporary files
    rm -rf /var/log/ninja-agent /tmp/ninja-agent
    echo "Cleanup completed."
}

# Function to uninstall TeamViewer
uninstall_teamviewer() {
    echo "Uninstalling TeamViewer..."
    # Assume TeamViewer is installed via a package manager
    if dpkg -l | grep -qw teamviewer; then
        apt-get remove --purge -y teamviewer
    fi
    echo "TeamViewer uninstalled successfully."
}

# Main script execution logic
if [ "$UNINSTALL" = "true" ]; then
    uninstall_ninja
fi

if [ "$CLEANUP" = "true" ]; then
    cleanup_files
fi

if [ "$DEL_TEAMVIEWER" = "true" ]; then
    uninstall_teamviewer
fi

# Error handling and logging
if [ "$SHOW_ERROR" = "true" ]; then
    # Redirect stderr to a file for error logging
    exec 2>/var/log/ninja-agent-errors.log
fi
