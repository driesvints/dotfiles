# superlumic-osx-defaults

Ansible role to set "defaults" on OSX. This role is part of the Superlumic project that aims to simplify repeat computer setups on OSX, 10.10 and up.

## Requirements

* OSX 10.10 or 10.11

## Role Variables

```yaml
    - osx_defaults:
      - domain: 'com.apple.dock'
        key: 'autohide'
        type: boolean
        value: true
      - domain: 'com.apple.dock'
        key: 'minimize-to-application'
        type: integer
        value: 1
      - domain: 'com.apple.dock'
        key: 'show-process-indicators'
        type: boolean
        value: true
      - domain: 'com.apple.dock'
        key: 'orientation'
        type: string
        value: left
      - domain: 'NSGlobalDomain'
        key: 'NSTableViewDefaultSizeMode'
        type: integer
        value: 1
      - domain: 'com.apple.screencapture'
        key: 'type'
        type: string
        value: png
      - domain: 'NSGlobalDomain'
        key: 'KeyRepeat'
        type: integer
        value: 2
      - domain: 'NSGlobalDomain'
        key: 'InitialKeyRepeat'
        type: integer
        value: 15
      - domain: 'com.apple.menuextra.clock'
        key: 'DateFormat'
        type: string
        value: EEE MMM d  HH:mm
      - domain: 'com.apple.menuextra.battery'
        key: 'ShowPercent'
        type: string
        value: 'YES'
      - domain: 'com.apple.finder'
        key: 'FXPreferredViewStyle'
        type: string
        value: "clmv"
      - domain: 'NSGlobalDomain'
        key: 'NSNavPanelExpandedStateForSaveMode'
        type: boolean
        value: true
      - domain: 'NSGlobalDomain'
        key: 'PMPrintingExpandedStateForPrint'
        type: boolean
        value: true
      - domain: 'com.apple.dock'
        key: 'tilesize'
        type: float
        value: 32
      - domain: 'com.apple.dock'
        key: 'autohide-time-modifier'
        type: int
        value: 0
      - domain: 'com.apple.dock'
        key: 'autohide-delay'
        type: int
        value: 0
      - domain: 'NSGlobalDomain'
        key: 'NSQuitAlwaysKeepsWindows'
        type: boolean
        value: false
      - domain: 'NSGlobalDomain'
        key: 'ApplePressAndHoldEnabled'
        type: boolean
        value: false
      - domain: 'com.apple.desktopservices'
        key: 'DSDontWriteNetworkStores'
        type: boolean
        value: true
      - domain: 'com.apple.print.PrintingPrefs'
        key: 'Quit When Finished'
        type: boolean
        value: true
```

# Usage

See above and check [Superlumic](https://github.com/superlumic/superlumic) for documentation

# License

MIT

# Author

[Hiroaki Nakamura]( http://hnakamur.github.io/ )
Modified by [Roderik van der Veer](mailto:roderik@superlumic.com) - [@r0derik](https://twitter.com/r0derik)
