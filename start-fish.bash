#!/usr/bin/env bash

# Function to clone or update the repository safely
update_repo() {
    local repo_url="https://github.com/Xanonymous-GitHub/warwick-dcs-init-config.git"
    local repo_path="$HOME/initial-scripts"

    # Clone or update the repository
    if [ -d "$repo_path/.git" ]; then
        git -C "$repo_path" pull --quiet --ff-only
    else
        git clone --quiet "$repo_url" "$repo_path"
    fi
}

# Function to verify the latest commit signature
verify_commit_signature() {
    local repo_path="$HOME/initial-scripts"
    git -C "$repo_path" log -1 --pretty=format:"%G?" | grep -q "G"
}

# Function to source the configuration script
run_config_script() {
    local script_path="$HOME/initial-scripts/config.bash"

    if [ -f "$script_path" ]; then
        # shellcheck disable=SC1090
        source "$script_path"
    else
        echo "Configuration script not found."
    fi
}

# Main function to handle the entire process
handle_fish_startup() {
    # Check if we are running interactively
    if [ -t 1 ]; then
        # Update and verify repo safely. Continue regardless of success.
        update_repo
        if verify_commit_signature; then
            echo "Commit signature verified."

            # Run config script safely. Continue regardless of execution result.
            run_config_script

            # Check the configuration and start fish if enabled
            if [ "${USE_FISH_SHELL:-false}" = "true" ] && command -v fish &> /dev/null; then
                fish
                echo "Exited fish shell."
            else
                echo "Fish shell disabled in config or not found."
            fi
        else
            echo "Commit signature verification failed."
        fi
    fi
}

# Execute the whole process
handle_fish_startup
