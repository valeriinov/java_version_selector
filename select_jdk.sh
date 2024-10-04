#!/bin/bash

# Path to the JDK versions list file
JDK_VERSIONS_FILE="jdk_versions.properties"

# Path to the gradle.properties file
GRADLE_PROPERTIES_FILE="$HOME/.gradle/gradle.properties"

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
    echo "Select JDK version:"
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

# Function to update the gradle.properties file
update_gradle_properties() {
    local jdk_path="$1"
    
    if [ ! -f "$GRADLE_PROPERTIES_FILE" ]; then
        mkdir -p "$(dirname "$GRADLE_PROPERTIES_FILE")"
        touch "$GRADLE_PROPERTIES_FILE"
    fi
    
    if [ "$jdk_path" == "DEFAULT" ]; then
        if grep -q '^org.gradle.java.home=' "$GRADLE_PROPERTIES_FILE"; then
            sed -i.bak '/^org.gradle.java.home=/d' "$GRADLE_PROPERTIES_FILE" && rm "${GRADLE_PROPERTIES_FILE}.bak"
            echo "JDK setting removed from $GRADLE_PROPERTIES_FILE"
        else
            echo "No JDK setting found in $GRADLE_PROPERTIES_FILE"
        fi
    else
        # Check if the JDK path exists
        if check_jdk_path "$jdk_path"; then
            if grep -q '^org.gradle.java.home=' "$GRADLE_PROPERTIES_FILE"; then
                sed -i.bak "s|^org.gradle.java.home=.*|org.gradle.java.home=$jdk_path|" "$GRADLE_PROPERTIES_FILE" && rm "${GRADLE_PROPERTIES_FILE}.bak"
            else
                echo "org.gradle.java.home=$jdk_path" >> "$GRADLE_PROPERTIES_FILE"
            fi
            echo "File $GRADLE_PROPERTIES_FILE updated. Set path: $jdk_path"
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
    update_gradle_properties "DEFAULT"
elif [ "$choice" -ge 1 ] && [ "$choice" -le ${#versions[@]} ]; then
    selected_path="${paths[$((choice-1))]}"
    update_gradle_properties "$selected_path"
else
    echo "Invalid choice."
    exit 1
fi

# Display the content of gradle.properties file after update
echo "Current content of $GRADLE_PROPERTIES_FILE:"
cat "$GRADLE_PROPERTIES_FILE"