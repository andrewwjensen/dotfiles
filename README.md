# Chezmoi Setup

Manual steps required after initializing a system with chezmoi.

## Prerequisites

1. Install chezmoi:

   ```sh
   sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply andrewwjensen
   ```

   > This will prompt for the encryption key password, which is the same as my 1Password account password.

## Manual Steps

> **Note:** Many of these steps are Mac-specific.

1. Change Caps Lock to Control
2. Remove the system-wide Spotlight keyboard shortcut: `⌘-⌥-Space`
3. Install Apps:
   - Paste
   - iTerm2
   - Emacs
   - JetBrains Toolbox (then install tools as needed via the Toolbox)
   - Beyond Compare
   - Chrome
   - Firefox
   - Spotify
   - GraphicConverter

4. For `amplify push` to work:

   ```sh
   sudo chown -R $(whoami):staff /usr/local/*
   npm uninstall -g node
   npm install -g n
   n 20.10.0
   npm install -g @aws-amplify/cli@12.10.0
   npm install -g npm@10.2.5
   ```
5. Install Python versions via pyenv:

   ```sh
   pyenv install 3.11.15
   pyenv install 3.14.6
   pyenv global 3.14.6
   ```
   
6. Check out unix-environment repo and compile custom tools:

   ```sh
   git clone https://bitbucket.org/andrewwjensen/unix-environment.git
   (cd ~/unix-environment/bin/src/mine; bazel build --verbose_failures :all) && d
   ```