# `PFunc`

__Control LEGO® Powered Up motors, lights and sensors from an `@Observable` Swift interface.__

`PFunc` communicates with [LEGO® Powered Up](https://www.lego.com/themes/powered-up) hubs over Bluetooth Low Energy (BLE). [Core Bluetooth](https://developer.apple.com/documentation/corebluetooth) does the heavy lifting, managing connections and writing instructions to the hubs. `PFunc` implements _just_ enough of the [LEGO® Wireless Protocol](https://lego.github.io/lego-ble-wireless-protocol-docs) to replace the [88010 Remote Control](https://www.lego.com/product/remote-control-88010) and drive the current generation of Powered Up attachments from the 2- and 4-port consumer hubs.

### Supported Hubs

| [88012&nbsp;Technic™&nbsp;Hub](https://www.lego.com/product/technic-hub-88012) | [88009&nbsp;Hub](https://www.lego.com/product/hub-88009) |
| --- | --- |
| ![](docs/technic-hub-88012.png) | ![](docs/hub-88009.png) |

### Supported Attachments

| [88011&nbsp;Train&nbsp;Motor](https://www.lego.com/product/train-motor-88011) | [88013&nbsp;Technic™&nbsp;Large&nbsp;Motor](https://www.lego.com/product/technic-large-motor-88013) |
| --- | --- |
| ![](docs/train-motor-88011.png) | ![](docs/technic-large-motor-88013.png) |

| [88005&nbsp;Light](https://www.lego.com/product/light-88005) | &nbsp; |
| --- | --- |
| ![](docs/light-88005.png) | ![](docs/-.png) |

### Supported Platforms

Written in [Swift](https://developer.apple.com/documentation/swift) 6 for Apple stuff:

* [macOS](https://developer.apple.com/macos) 15 Sequoia
* [iOS](https://developer.apple.com/ios)/[iPadOS](https://developer.apple.com/ipad) 18
* [visionOS](https://developer.apple.com/visionos) 2

Build with [Xcode](https://developer.apple.com/xcode) 16 or newer.

### Acknowledgments

If you're reading this, good chance you actually want [Pybricks.](https://pybricks.com) If I'm LEGO, I totally rebase [LPF2](https://brickarchitect.com/powered-up) on Pybricks; it's just _astonishingly_ good. I'm headed there next myself.

Unfortunately, I wanted a _native_ Mac/iOS app that connects and drives any Powered Up train hub _running any version of stock LPF2 firmware_. And slogging through dogshit Bluetooth APIs seems to be my karmic penance for something horrible done in a previous life. Fortunately, a few others already slogged:

* [Notes on LEGO wireless BLE protocol](https://virantha.github.io/bricknil/lego_api/lego.html)
* [Powered UP - Community Docs (the missing device docs ...)](https://github.com/sharpbrick/docs)
* [SmartBotKit LWP](https://github.com/smartbotkit/lwp)
