#!/bin/zsh
# Builds ClipStash.app next to this script.
set -e
cd "$(dirname "$0")"
APP=ClipStash.app
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
swiftc -O -swift-version 5 main.swift -o "$APP/Contents/MacOS/ClipStash" -framework Cocoa -framework Carbon
cat > "$APP/Contents/Info.plist" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key><string>ClipStash</string>
  <key>CFBundleDisplayName</key><string>ClipStash</string>
  <key>CFBundleIdentifier</key><string>local.clipstash</string>
  <key>CFBundleExecutable</key><string>ClipStash</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>LSMinimumSystemVersion</key><string>13.0</string>
  <key>LSUIElement</key><true/>
  <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
EOF
# Sign with a stable identity (bundle id) instead of the per-build hash, so macOS
# keeps the Screen Recording permission across rebuilds.
codesign --force --sign - -r='designated => identifier "local.clipstash"' "$APP"
echo "Built $(pwd)/$APP"
