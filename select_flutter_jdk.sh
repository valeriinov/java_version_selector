#!/bin/bash

# Path to the JDK versions list file
JDK_VERSIONS_FILE="jdk_versions.properties"

# Function to read the jdk_versions.properties file
read_jdk_versions() {
    if [ ! -f "$JDK_VERSIONS_FILE" ]; then
        echo "File $JDK_VERSIONS_FILE not found."
        exit 1
    fi

    versions=($(grep -v '^#' "$JDK_VERSIONS_FILE" | cut -d '=' -f 1))
    paths=($(grep -v '^#' "$JDK_VERSIONS_FILE" | cut -d '=' -f 2-))
}

# Function to display the JDK version selection menu
show_menu() {
    echo "Select JDK version for Flutter:"
    for i in "${!versions[@]}"; do
        echo "$((i+1)). ${versions[i]}"
    done
    echo "$((${#versions[@]}+1)). DEFAULT (remove setting)"
    echo "Enter the number of your choice:"
}

# Function to check if the JDK path exists
check_jdk_path() {
    local jdk_path="$1"
    if [ ! -d "$jdk_path" ]; then
        echo "Error: JDK path does not exist: $jdk_path"
        return 1
    fi
    return 0
}

# Function to update Flutter JDK config
update_flutter_jdk_config() {
    local jdk_path="$1"

    if [ "$jdk_path" == "DEFAULT" ]; then
        flutter config --jdk-dir=
        echo "Flutter JDK setting reset to default."
    else
        # Check if the JDK path exists
        if check_jdk_path "$jdk_path"; then
            flutter config --jdk-dir="$jdk_path"
            echo "Flutter JDK path set to: $jdk_path"
        else
            echo "Skipping update due to invalid JDK path."
            return 1
        fi
    fi
}

# Main script logic
read_jdk_versions
show_menu

read choice
if [ "$choice" -eq $((${#versions[@]}+1)) ]; then
    update_flutter_jdk_config "DEFAULT"
elif [ "$choice" -ge 1 ] && [ "$choice" -le ${#versions[@]} ]; then
    selected_path="${paths[$((choice-1))]}"
    update_flutter_jdk_config "$selected_path"
else
    echo "Invalid choice."
    exit 1
fi

# Display the current Flutter config
echo "Current Flutter config:"
flutter config --list
