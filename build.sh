#!/bin/zsh
# Builds ClipStash.app next to this script.
set -e
cd "$(dirname "$0")"
VERSION=${VERSION:-1.0}
rm -rf ClipStash.app
mkdir -p ClipStash.app/Contents/MacOS ClipStash.app/Contents/Resources
swiftc -O -swift-version 5 main.swift -o ClipStash.app/Contents/MacOS/ClipStash -framework Cocoa -framework Carbon
swift make_icon.swift list.clipboard 5B8CFF 3A3FD9 ClipStash.app/Contents/Resources/AppIcon.icns
cat > ClipStash.app/Contents/Info.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key><string>ClipStash</string>
  <key>CFBundleDisplayName</key><string>ClipStash</string>
  <key>CFBundleIdentifier</key><string>local.clipstash</string>
  <key>CFBundleExecutable</key><string>ClipStash</string>
  <key>CFBundleIconFile</key><string>AppIcon</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>$VERSION</string>
  <key>CFBundleVersion</key><string>$VERSION</string>
  <key>LSApplicationCategoryType</key><string>public.app-category.utilities</string>
  <key>LSMinimumSystemVersion</key><string>13.0</string>
  <key>LSUIElement</key><true/>
  <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
EOF
# Sign with a stable identity (bundle id) instead of the per-build hash, so macOS
# keeps the Accessibility permission across rebuilds.
codesign --force --sign - -r='designated => identifier "local.clipstash"' ClipStash.app
echo "Built $(pwd)/ClipStash.app"
