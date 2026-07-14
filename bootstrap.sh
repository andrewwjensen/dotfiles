#!/bin/bash
set -eufo pipefail

GITHUB_USER="andrewwjensen"
REPO_NAME="dotfiles"
KEY_DIR="$HOME/.config/age"
KEY_PATH="$KEY_DIR/key.txt"

# Create a unique, secure temporary file path for the encrypted downloded key
TEMP_ENC_KEY=$(mktemp /tmp/key.txt.age.XXXXXX)

# Define a cleanup function
cleanup() {
    echo "Cleaning up temporary installation files..."
    rm -f "$TEMP_ENC_KEY" "$HOME/bootstrap.sh" "$HOME/key.txt.age"
}

# Register the cleanup function to run once when the script exits
trap cleanup EXIT

echo "========================================="
echo "   Starting Dotfiles Bootstrap Process   "
echo "========================================="

# 1. Install dependencies (age and chezmoi) if missing
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

# 2. Setup age directory and decrypt the key
mkdir -p "$KEY_DIR"

if [ ! -f "$KEY_PATH" ]; then
    echo "Downloading encrypted key file..."
    curl -sL "https://raw.githubusercontent.com/${GITHUB_USER}/${REPO_NAME}/main/key.txt.age" -o "$TEMP_ENC_KEY"

    echo "Enter your passphrase to decrypt your age key:"
    if ! age -d -o "$KEY_PATH" "$TEMP_ENC_KEY"; then
        echo "Error: Incorrect passphrase. Failed to decrypt key." >&2
        exit 1
    fi

    chmod 600 "$KEY_PATH"
    echo "Private key decrypted and saved securely to $KEY_PATH"
fi

# 3. Run chezmoi
echo "Initializing and applying chezmoi..."
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply andrewwjensen

echo "========================================="
echo "        Bootstrap Complete!              "
echo "========================================="
