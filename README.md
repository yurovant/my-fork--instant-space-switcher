# InstantSpaceSwitcher

Native instant workspace switching on macOS. No more waiting for animations.

## Features

- Does not require disabling SIP
- Uses native macOS spaces
- Free

A simple CLI is provided (`InstantSpaceSwitcher.app/Contents/MacOS/ISSCli --help`)

## Local development (build, run, debug)

## Prerequisites (macOS)

Before running the build steps below, ensure your machine is set up with:

1. A recent macOS version with Xcode installed.

2. Xcode Command Line Tools configured:

`xcode-select -p`

If this command fails, install Command Line Tools first:

`xcode-select --install`

3. Xcode license accepted (required by xcodebuild on fresh installs):

`sudo xcodebuild -license accept`

4. Accessibility permission can be granted to the app when prompted. The app builds without this, but global hotkeys and switching behavior depend on it.

### Build and run locally

If you also have a Homebrew-installed copy in `/Applications`, quit it first so only one process is running:

```sh
pkill -x InstantSpaceSwitcher
```

Build a local app bundle:

```sh
./dist/build.sh --debug
```

Run the local app:

```sh
open ./build/InstantSpaceSwitcher.app
```

### Fast debug loop

For quick iteration without producing a `.app` bundle each time:

```sh
swift build
./.build/debug/InstantSpaceSwitcher
```

### Useful debug commands

Kill the running app:

```sh
pkill -x InstantSpaceSwitcher
```

Tail app logs from unified logging:

```sh
log stream --style compact --predicate 'process == "InstantSpaceSwitcher"'
```

### Reset Accessibility permissions

If hotkeys stop working after rebuilding/moving the app, reset TCC Accessibility and relaunch:

```sh
tccutil reset Accessibility com.interversehq.InstantSpaceSwitcher
```

After reset, start the app again and re-allow it in:

`System Settings -> Privacy & Security -> Accessibility`

### Optional cleanup

Remove local build artifacts:

```sh
rm -rf ./build
rm -rf ./.build
```

### Troubleshooting / First time startup

1. When opening the app the first time you are likely to run into any of the following warnings:

> "Apple could not verify InstantSpaceSwitcher.app is free of malware"

> "App is damaged and can’t be opened"

> "App can't be opened because the developer cannot be verified"

Please follow the instructions [here](https://wiki.hacks.guide/wiki/Open_unsigned_applications_on_macOS_Sequoia_and_newer) for instructions on how to allow the app to run[^1].

2. Afterward you will get a warning that InstantSpaceSwitcher wants to use accessibility features. You have to allow this.

3. Then open the app from the Applications folder and the configuration window should appear.

## Background

When I first bought a high refresh rate monitor, around ~2018, I could tell that the space switching animation was longer because it had scaled with the refresh rate. Because of this, I eventually stopped using spaces altogether, and have been looking for a solution ever since.

The workaround in this project is to create a synthetic trackpad gesture with an artificially high velocity. This effectively skips the animation.

If you work at Apple, and your team owns the space switching animation, please fix this long-standing bug[^2] (and let us disable the animation natively, please).

[^1]: This happens because the app is not signed, which requires a costly Apple Developer account

[^2]: And I know for a fact there is a rdar for this
