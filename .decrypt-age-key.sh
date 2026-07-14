#!/usr/bin/env bash
set -euo pipefail
umask 077

KEY_PATH="${HOME}/.config/chezmoi/key.txt"

# Skip if the key is already present and valid
if [[ -s "$KEY_PATH" ]]; then
  exit 0
fi

# 1. Install dependencies (brew and age) if missing
echo "Checking system dependencies..."
OS="$(uname -s)"
if ! command -v age &> /dev/null; then
    echo "Installing age encryption tool..."
    if [[ "$OS" == "Darwin" ]]; then
        # Check if Homebrew is missing on Mac, install it first
        if ! command -v brew &> /dev/null; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install age
    elif [[ "$OS" == "Linux" ]]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y age
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm age
        else
            echo "Unsupported Linux distribution. Please install 'age' manually." >&2
            exit 1
        fi
    fi
fi

mkdir -p "$(dirname "$KEY_PATH")"

# 2. Decrypt the key using age (this will prompt you for your passphrase)
if command -v age &>/dev/null; then
  age --decrypt --output "$KEY_PATH" "${HOME}/.local/share/chezmoi/key.txt.age"
else
  echo "Error: 'age' binary is required but not installed." >&2
  exit 1
fi

chmod 600 "$KEY_PATH"
