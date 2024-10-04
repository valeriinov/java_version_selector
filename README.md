# JDK Version Selector

This bash script allows you to easily switch between different JDK versions for your Android project
builds by updating the `gradle.properties` file. It includes a safety check to ensure the selected
JDK path exists before making any changes.

## Prerequisites

- Bash shell
- Multiple JDK versions installed on your system
- Gradle configuration directory located at `$HOME/.gradle/`

## Setup

1. Create a file named `jdk_versions.properties` in the same directory as the script with the
   following format:

```
<version>=<path_to_jdk>
```

For example:

```
17=/opt/homebrew/Cellar/openjdk@17/17.0.12/libexec/openjdk.jdk/Contents/Home
23=/opt/homebrew/Cellar/openjdk/23/libexec/openjdk.jdk/Contents/Home
```

2. Make sure the script `select_jdk.sh` is in the same directory as `jdk_versions.properties`.

3. Make the script executable:

```bash
chmod +x select_jdk.sh
```

## Usage

1. Run the script:

```bash
./select_jdk.sh
```

2. You will see a menu with available JDK versions and a DEFAULT option:

```
Select JDK version:
1. 17
2. 23
3. DEFAULT (remove setting)
Enter the number of your choice:
```

3. Enter the number corresponding to your choice:
    - Selecting a JDK version will update the `org.gradle.java.home` property in your
      `~/.gradle/gradle.properties` file if the JDK path exists.
    - Selecting DEFAULT will remove the `org.gradle.java.home` property from the file.

4. The script will display the updated contents of the `gradle.properties` file after making
   changes.

## Notes

- The script assumes that your Gradle configuration directory is located at `$HOME/.gradle/`. This
  is the default location for most Gradle installations.
- If the `~/.gradle/gradle.properties` file doesn't exist, the script will create it.
- The script checks if the selected JDK path exists before making any changes. If the path is
  invalid, it will skip the update and display an error message.
- Make sure to update the `jdk_versions.properties` file whenever you install a new JDK version or
  change the installation path.

## Troubleshooting

If you encounter any issues:

1. Ensure that the paths in `jdk_versions.properties` are correct and accessible.
2. Check that you have write permissions for the `~/.gradle/gradle.properties` file.
3. Verify that your Gradle configuration directory is indeed located at `$HOME/.gradle/`. If it's in
   a different location, you'll need to modify the `GRADLE_PROPERTIES_FILE` variable in the script.
4. If you're using a non-bash shell, try running the script with `bash select_jdk.sh`.
5. If the script reports that a JDK path doesn't exist, verify the path in `jdk_versions.properties`
   and ensure the JDK is properly installed.

