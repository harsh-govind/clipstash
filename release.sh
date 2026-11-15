#!/bin/zsh
# Builds ClipStash.app and packages it as dist/ClipStash-<version>.dmg (drag-to-Applications installer).
set -e
cd "$(dirname "$0")"
export VERSION=${1:-1.0}
./build.sh
rm -rf dist
mkdir -p dist/stage
cp -R ClipStash.app dist/stage/
ln -s /Applications dist/stage/Applications
hdiutil create -quiet -volname ClipStash -srcfolder dist/stage -ov -format UDZO "dist/ClipStash-$VERSION.dmg"
rm -rf dist/stage
echo "Created $(pwd)/dist/ClipStash-$VERSION.dmg"
