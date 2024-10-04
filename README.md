# JDK Version Selector

This set of bash scripts allows you to easily switch between different JDK versions for your Android
project builds by updating the gradle.properties file or Flutter configuration. They include safety
checks to ensure the selected JDK path exists before making any changes.

## Prerequisites

- Bash shell
- Multiple JDK versions installed on your system
- Gradle configuration directory located at `$HOME/.gradle/` (for select_jdk.sh)
- Flutter installed (for select_flutter_jdk.sh)

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

For select_jdk.sh:

```bash
chmod +x select_jdk.sh
```

For select_flutter_jdk.sh:

```bash
chmod +x select_flutter_jdk.sh
```

## Usage

# select_jdk.sh (Android)

This script updates the org.gradle.java.home property in your gradle.properties file.

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

# select_flutter_jdk.sh (Flutter)

This script sets the JDK path for Flutter builds.

1. Run the script:

```bash
./select_flutter_jdk.sh
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

- Selecting a JDK version will execute flutter config --jdk-dir=<path_to_jdk> to set the JDK path
  for Flutter builds.
- Selecting DEFAULT will reset to the default JDK by executing flutter config --jdk-dir=.

4. View the current Flutter configuration after changes.

## Notes

For Android (select_jdk.sh)

- Gradle Configuration Location: The script assumes your Gradle configuration directory is located
  at $HOME/.gradle/. This is the default location for most Gradle installations.
- Creating gradle.properties: If the ~/.gradle/gradle.properties file doesn't exist, the script will
  create it.
- Property Modification: The script modifies the org.gradle.java.home property in the
  gradle.properties file.
- Write Permissions: Ensure that you have write permissions for the ~/.gradle/gradle.properties
  file.

For Flutter (select_flutter_jdk.sh)

- Flutter Availability: The script assumes that Flutter is installed and accessible via the flutter
  command in your system's $PATH.
- Configuration Command: The script uses flutter config --jdk-dir=<path> to set the JDK for Flutter
  builds.

General

- JDK Path Validation: The scripts check if the selected JDK path exists before making any changes.
  If the path is invalid, they will skip the update and display an error message.
- Updating jdk_versions.properties: Make sure to update the jdk_versions.properties file whenever
  you install a new JDK version or change the installation path.
- Shared Configuration File: Both scripts rely on the jdk_versions.properties file for available JDK
  versions and their paths.

## Troubleshooting

If you encounter any issues:

General

- Invalid JDK Paths: Ensure that the paths in jdk_versions.properties are correct and that the JDKs
  are properly installed.
- Permission Issues: Ensure that you have write permissions for the necessary configuration files.

For Android (select_jdk.sh)

- Gradle Directory Location: Verify that your Gradle configuration directory is located at $
  HOME/.gradle/. If it's in a different location, modify the GRADLE_PROPERTIES_FILE variable in the
  script.
- Shell Compatibility: If you're using a non-bash shell, try running the script with bash
  select_jdk.sh.

For Flutter (select_flutter_jdk.sh)

- Flutter Command Not Found: Ensure that Flutter is installed and accessible via the flutter command
  in your system's $PATH.

