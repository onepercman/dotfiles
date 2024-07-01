#!/bin/zsh

# Function to print usage
usage() {
  echo "Usage: $0 [-w workspace_name]"
  exit 1
}

# Flag to check if workspace name was provided
workspace_provided=false

# Parse arguments
while getopts ":w:" opt; do
  case ${opt} in
  w)
    WORKSPACE_NAME=$OPTARG
    workspace_provided=true
    ;;
  \?)
    usage
    ;;
  esac
done

# Install Homebrew
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed"
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh is already installed"
fi

# Install NVM
if ! command -v nvm &>/dev/null; then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | zsh
else
  echo "NVM is already installed"
fi

# Source NVM script to start using it in the current session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install the latest LTS version of Node.js using NVM
echo "Installing the latest LTS version of Node.js..."
nvm install --lts

# Set default Node.js version
echo "Setting default Node.js version..."
nvm alias default $(nvm current)

# Copy dotfiles to home directory
echo "Copying dotfiles..."
for file in .??*; do
  if [[ -f $file ]]; then
    cp -v "$file" ~/
  fi
done

# Create workspace directory if workspace name was provided
if $workspace_provided; then
  if [ ! -d "$HOME/$WORKSPACE_NAME" ]; then
    echo "Creating workspace directory: $HOME/$WORKSPACE_NAME"
    mkdir -v "$HOME/$WORKSPACE_NAME"
  else
    echo "Workspace directory already exists: $HOME/$WORKSPACE_NAME"
  fi
else
  echo "No workspace name provided; skipping workspace creation."
fi

echo "Setup complete!"
