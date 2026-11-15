# ClipStash

A clipboard history for macOS that lives in the menu bar. It remembers the **text and images** you copy, and the history popup is **hidden from screen sharing**.

## Features

- **⌘⇧V** anywhere opens your history next to the mouse pointer; type to search
- **↩** or click pastes into the app you were in · **⌥↩** copies only · **⌘1–9** quick paste
- **⌘P** pin (pinned clips stay on top and are never trimmed) · **⌘⌫** delete · **esc** close
- Stores text and images (deduplicated); keeps the last 500 items plus anything pinned
- History window is excluded from screen sharing, recordings and screenshots (`NSWindow.sharingType = .none`)
- Skips secrets that password managers mark as concealed/transient
- Menu bar menu: last 10 clips, Pause Recording, Launch at Login, Clear History
- History is stored locally in `~/Library/Application Support/ClipStash/` (owner-only permissions)

## Build & run

Requires macOS 13+ and the Xcode command line tools (`xcode-select --install`).

```bash
./build.sh
open ClipStash.app
```

Grant **Accessibility** permission (System Settings → Privacy & Security → Accessibility) so ClipStash can paste into other apps. Without it, choosing a clip copies it and you press ⌘V yourself.

If another clipboard app already uses ⌘⇧V, quit it first.

> Note: newer macOS versions may not honor `sharingType = .none` for every screen-sharing app. Test with your meeting app before relying on it.

## How it works

A single Swift file (`main.swift`): an `NSStatusItem`, a timer that watches `NSPasteboard.changeCount`, a Carbon global hotkey, and a non-activating `NSPanel` for the history.
