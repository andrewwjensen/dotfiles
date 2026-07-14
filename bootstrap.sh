#!/bin/bash
set -eufo pipefail

# 1. Download decryption key securely
mkdir -p ~/.config/age
curl https://github.com/andrewwjensen/files/raw/refs/heads/main/key.txt.zip --output-dir /tmp/

# 2. Unzip the key file; this will prompt for a password to be entered in the terminal (Mac only)
ditto -x -k /tmp/key.txt.zip "${HOME}"
# On Linux, you can use the following command instead of ditto:
# unzip /tmp/key.txt.zip -d "${HOME}"

# 3. Fire off chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply andrewwjensen
