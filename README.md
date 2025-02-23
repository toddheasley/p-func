# `PFunc`

__Control LEGO® Powered Up motors, lights and sensors from an `@Observable` Swift interface__

`PFunc` talks to [LEGO® Powered Up](https://www.lego.com/themes/powered-up) hubs over Bluetooth Low Energy (BLE). [Core Bluetooth](https://developer.apple.com/documentation/corebluetooth) does the heavy lifting, managing connections and writing instructions to the hubs.

`PFunc` implements _just_ enough of the [LEGO® Wireless Protocol](https://lego.github.io/lego-ble-wireless-protocol-docs) to replace the [88010 Remote Control](https://www.lego.com/product/remote-control-88010) and drive the current generation of Powered Up attachments from the 2- and 4-port consumer hubs.

### Supported Hubs

| [88012&nbsp;Technic™&nbsp;Hub](https://www.lego.com/product/technic-hub-88012) | [88009&nbsp;Hub](https://www.lego.com/product/hub-88009) |
| --- | --- |
| ![](docs/technic-hub-88012.png) | ![](docs/hub-88009.png) |

### Supported Attachments

| [88011&nbsp;Train&nbsp;Motor](https://www.lego.com/product/train-motor-88011) | [88013&nbsp;Technic™&nbsp;Large&nbsp;Motor](https://www.lego.com/product/technic-large-motor-88013) |
| --- | --- |
| ![](docs/train-motor-88011.png) | ![](docs/technic-large-motor-88013.png) |

| [45303&nbsp;Motor](https://www.lego.com/product/simple-medium-linear-motor-45303) | [88005&nbsp;Light](https://www.lego.com/product/light-88005) |
| --- | --- |
| ![](docs/simple-medium-linear-motor-45303.png | ![](docs/light-88005.png) |

### Supported Platforms

Written in [Swift](https://developer.apple.com/documentation/swift) 6 for Apple stuff:

* [macOS](https://developer.apple.com/macos) 15 Sequoia
* [iOS](https://developer.apple.com/ios)/[iPadOS](https://developer.apple.com/ipad) 18
* [visionOS](https://developer.apple.com/visionos) 2

Build with [Xcode](https://developer.apple.com/xcode) 16 or newer.

## Examples

Apps using `PFunc` are using Core Bluetooth. Your app will crash if its `Info.plist` doesn't include `NSBluetoothAlwaysUsageDescription` [privacy description.](https://developer.apple.com/documentation/uikit/protecting_the_user_s_privacy/requesting_access_to_protected_resources)

Additionally, app entitlements should enable Bluetooth:

| macOS | iOS, visionOS |
| --- | --- |
| ![](docs/entitlements-app-sandbox.png) | ![](docs/entitlements-background-modes.png) |

[Adding package dependencies](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)

```swift
import SwiftUI
import PFunc

@main
struct App: SwiftUI.App {
    @State private var pFunc: PFunc = PFunc()
    
    // MARK: App
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(pFunc)
        }
    }
}
```

## Acknowledgments

There's a good chance you actually want [Pybricks](https://pybricks.com), not this library. A fork of this project is looking for a way to package Pybricks so it's [App Review](https://developer.apple.com/distribute/app-review) legal, because that's what _I'd_ like to be running on my LEGO kit.

Unfortunately, even if I figure that out _and_ learn Python, I still want a native Mac/iOS app that can drive Powered Up train hubs _running stock [LPF2](https://brickarchitect.com/powered-up) firmware_. No avoiding a slog through LWP. Fortunately, others already slogged:

* [Notes on LEGO wireless BLE protocol](https://virantha.github.io/bricknil/lego_api/lego.html)
* [Powered UP - Community Docs (the missing device docs ...)](https://github.com/sharpbrick/docs)
* [SmartBotKit LWP](https://github.com/smartbotkit/lwp)
