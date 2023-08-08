#!/usr/bin/env bash

# Change the names according to your project
PROJECT_NAME="hash_demo"
FLUTTER_APP_NAME="counter"

# check if we are in hash_demo folder
if [[ "$(basename "$(pwd)")" != $PROJECT_NAME ]]; then
  echo "Current directory is not $PROJECT_NAME"
  exit 1
fi

# Go to counter folder
cd $FLUTTER_APP_NAME

# Build flutter web app in release mode with canvas kit in counter folder
flutter build web --web-renderer canvaskit --release --csp

# Go to root folder
cd ..

# Remove public folder if exists
if [ -d "public/" ]; then
  rm -rf public/
fi

# copy the hash_demo/build/web folder to public folder
cp -r $FLUTTER_APP_NAME/build/web/ public/
