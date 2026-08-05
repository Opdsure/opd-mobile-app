#!/bin/bash

echo "🚀 Fixing CocoaPods and Fastlane issues in Jenkins..."

# Ensure UTF-8 Encoding
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "✅ Ensured UTF-8 encoding"

# Ensure correct Ruby version
if ! command -v rbenv &> /dev/null; then
  echo "⚠️ rbenv is not installed! Installing now..."
  brew install rbenv
  rbenv init
fi

rbenv global 3.2.0
rbenv rehash
echo "✅ Ruby version: $(ruby -v)"

# Ensure Bundler is installed
if ! gem list bundler -i; then
  echo "⚠️ Bundler is missing! Installing now..."
  gem install bundler
fi

# Navigate to iOS project folder
cd ios || exit 1

# Remove old Pods and reinstall
rm -rf Pods Podfile.lock
bundle install || gem install bundler && bundle install
pod install --repo-update

if [ $? -ne 0 ]; then
  echo "❌ pod install failed! Trying again..."
  pod deintegrate
  pod setup
  pod install --repo-update
fi

echo "✅ CocoaPods setup completed successfully!"
