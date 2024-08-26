#!/bin/bash

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to the system path if needed
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
    source ~/.zshrc
else
    echo "Homebrew is already installed."
fi

# Update and upgrade Homebrew
echo "Updating Homebrew..."
brew update
brew upgrade

# Check if Xcode Command Line Tools are installed
if ! xcode-select -p &> /dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
else
    echo "Xcode Command Line Tools are already installed."
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "Installing Flutter..."
    brew install --cask flutter
else
    echo "Flutter is already installed."
fi

# Set up Flutter environment variables (if not already set)
if ! grep -q 'export PATH="$PATH:/usr/local/Caskroom/flutter/latest/flutter/bin"' ~/.zshrc; then
    echo "Setting up Flutter environment variables..."
    echo 'export PATH="$PATH:/usr/local/Caskroom/flutter/latest/flutter/bin"' >> ~/.zshrc
    source ~/.zshrc
else
    echo "Flutter environment variables are already set."
fi

# Check if Android Studio is installed
if [ ! -d "/Applications/Android Studio.app" ]; then
    echo "Installing Android Studio..."
    brew install --cask android-studio
else
    echo "Android Studio is already installed."
fi

# Check if Android SDK Command-line Tools are installed
if ! command -v sdkmanager &> /dev/null; then
    echo "Installing Android SDK Command-line Tools..."
    brew install --cask android-sdk
else
    echo "Android SDK Command-line Tools are already installed."
fi

# Accept Android licenses if not accepted
if flutter doctor --android-licenses | grep -q "All SDK package licenses accepted"; then
    echo "Android SDK licenses are already accepted."
else
    echo "Accepting Android SDK licenses..."
    yes | flutter doctor --android-licenses
fi

# Install additional Flutter dependencies (AdoptOpenJDK)
if ! java -version 2>&1 | grep -q "openjdk version"; then
    echo "Installing AdoptOpenJDK..."
    brew install --cask adoptopenjdk/openjdk/adoptopenjdk8
else
    echo "AdoptOpenJDK is already installed."
fi

# Check if Visual Studio Code is installed
# Check if Visual Studio Code is installed
if command -v code &> /dev/null; then
    echo "Visual Studio Code is already installed."
else
    echo "Installing Visual Studio Code..."
    brew install --cask visual-studio-code
fi


# Check if IntelliJ IDEA is installed (optional)
# if [ ! -d "/Applications/IntelliJ IDEA.app" ]; then
#     echo "Installing IntelliJ IDEA..."
#     brew install --cask intellij-idea
# else
#     echo "IntelliJ IDEA is already installed."
# fi

# Guide to install full Xcode
if [ ! -d "/Applications/Xcode.app" ]; then
    echo "Opening the Mac App Store to Xcode. Please install Xcode manually."
    open "macappstore://itunes.apple.com/app/id497799835?mt=12"
else
    echo "Xcode is already installed."
    echo "Running post-installation Xcode commands..."
    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
    sudo xcodebuild -runFirstLaunch
fi

# Check if CocoaPods is installed using Homebrew
if ! command -v pod &> /dev/null; then
    echo "Installing CocoaPods using Homebrew..."
    brew install cocoapods
else
    echo "CocoaPods is already installed."
fi

# Run Flutter doctor to check the setup
echo "Running Flutter doctor to check the setup..."
flutter doctor

echo "Flutter development environment setup is complete!"
