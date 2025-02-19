#!/bin/bash

# Function to find .env files safely.
#  - Uses 'find' with appropriate options.
#  - Excludes standard directories that should never be scanned for this.
#  - Prompts for confirmation before deletion.

find_and_delete_env() {
  local root_dir="$1"

  # Find .env files, excluding critical system directories.
  #   - The '-type f' ensures we only find files.
  #   - The '-name ".env"' specifies the filename.
  #   - The '-print' prints the full path of each found file.
  #   - A series of '-not -path' options exclude system directories
  #     and potentially problematic locations.  Adjust these as needed
  #     for your specific setup.  This is the MOST IMPORTANT part
  #     to customize to prevent accidental deletion of critical system files.
  find "$root_dir" \
    -type f \
    -name ".env" \
    -not -path "/System/*" \
    -not -path "/Library/*" \
    -not -path "/usr/*" \
    -not -path "/bin/*" \
    -not -path "/sbin/*" \
    -not -path "/private/var/db/SystemPolicyConfiguration/*" \
    -not -path "/dev/*" \
    -not -path "/Volumes/*" \
    -print0 | \
  while IFS= read -r -d $'\0' file; do
    echo "Found .env file: $file"
    read -r -p "Delete this file? (y/N) " response
    if [[ "$response" =~ ^[yY]$ ]]; then
      if [[ -f "$file" ]]; then  # Double-check it's still a file
        rm -f "$file"
        if [[ $? -eq 0 ]]; then
          echo "Deleted: $file"
        else
          echo "ERROR: Failed to delete: $file"
        fi
      else
        echo "WARNING: $file no longer exists."
      fi
    fi
  done
}

# --- Main Script ---

# 1. Find and delete on the local machine's root.
echo "Searching local filesystem..."
find_and_delete_env /

# 2.  Find and delete in mounted cloud drives.  This part needs
#     CAREFUL customization for YOUR setup.  You MUST know where your
#     cloud drives are mounted.  Do NOT guess!
#     Use the 'mount' command in the terminal to see mounted volumes.
#
#     Example (replace with your actual mount points):
#     echo "Searching iCloud Drive..."
#     find_and_delete_env "$HOME/Library/Mobile Documents/com~apple~CloudDocs"  # macOS iCloud
#
#     echo "Searching Google Drive..."
#     find_and_delete_env "/Volumes/GoogleDrive"  # Example - could be different
#
#     echo "Searching OneDrive..."
#     find_and_delete_env "/Volumes/OneDrive"   # Example - could be different
#
#     Add more cloud drive locations as needed, using the correct paths.
#     If you are unsure, DO NOT RUN this part of the script.

# **Important Considerations:**

# * **Backups:** Make a complete backup of your system *before* running this.
# * **Cloud Drive Mount Points:** You *must* replace the example cloud drive
#   paths with the *correct* paths for your system. Use the `mount` command
#   in your terminal to see mounted volumes and their paths.  Incorrect paths
#   could lead to deleting the wrong files.
# * **Exclusions:** The `-not -path` options in the `find` command are crucial
#   for preventing accidental deletion of system files.  Carefully review
#   and adjust these exclusions to match your system's configuration.
# * **Permissions:** You may need to run this script with `sudo` if you
#   encounter permission errors when trying to delete files.  However,
#   be *extremely* careful when using `sudo`, as it grants elevated privileges.
# * **Testing:** Test this script THOROUGHLY in a safe, non-critical directory
#   *before* running it on your entire system.  Create a test directory,
#   put some dummy `.env` files in it, and run the script on that directory
#   to see how it behaves.
