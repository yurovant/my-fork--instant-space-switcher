#!/bin/bash
set -e

CLEAN=false
BUILD_CONFIG="release"

for arg in "$@"; do
  case "$arg" in
    --clean) CLEAN=true ;;
    --debug) BUILD_CONFIG="debug" ;;
    --help)
      echo "Usage: $0 [--clean] [--debug] [--help]"
      echo ""
      echo "Options:"
      echo "  --clean    Delete build directory before building"
      echo "  --debug    Build in debug mode (default: release)"
      echo "  --help     Show this help message"
      exit 0
      ;;
  esac
done

PRODUCT_NAME="InstantSpaceSwitcher"
BUILD_DIR="build"

if [[ "$CLEAN" == true ]]; then
  echo "Cleaning build directory..."
  rm -rf "${BUILD_DIR}"
fi

BUILD_PATH="${BUILD_DIR}/arm64/${BUILD_CONFIG}"
APP_BUNDLE="${BUILD_DIR}/${PRODUCT_NAME}.app"

echo "Building arm64..."
swift build -c "${BUILD_CONFIG}" --arch arm64 --build-path "${BUILD_DIR}/arm64" --disable-sandbox

echo ""
echo "Bundling..."
mkdir -p "${APP_BUNDLE}/Contents/MacOS"
mkdir -p "${APP_BUNDLE}/Contents/Resources"
cp "${BUILD_PATH}/${PRODUCT_NAME}" "${APP_BUNDLE}/Contents/MacOS/"
cp "${BUILD_PATH}/ISSCli" "${APP_BUNDLE}/Contents/MacOS/"
cp Info.plist "${APP_BUNDLE}/Contents/"

GIT_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
echo "Injecting git SHA: ${GIT_SHA}"
/usr/libexec/PlistBuddy -c "Add :GitCommitHash string ${GIT_SHA}" "${APP_BUNDLE}/Contents/Info.plist" 2>/dev/null || \
/usr/libexec/PlistBuddy -c "Set :GitCommitHash ${GIT_SHA}" "${APP_BUNDLE}/Contents/Info.plist"

echo ""
echo "Signing (ad-hoc)..."
codesign --force --deep --sign - "${APP_BUNDLE}"

echo ""
echo "App bundled at $(pwd)/${APP_BUNDLE} (${BUILD_CONFIG})"
