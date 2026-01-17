# FRP Module

This is a Magisk/KernelSU/APatch module that automatically downloads and installs the latest FRP (Fast Reverse Proxy) binary for Android devices, with support for boot auto-start and configurable config file path.

## Features

- Automatic download of the latest FRP version during installation
- Architecture detection (arm64/android_arm64, arm/linux_arm)
- Boot auto-start via service.sh
- Configurable config file path via config.sh
- Supports both FRP client and server modes

## Installation

1. Download the module zip file from the releases page.
2. Install via Magisk Manager, KernelSU Manager, or APatch Manager.
3. The module will automatically download the appropriate FRP binary.

## Configuration

After installation, edit `/data/adb/modules/frp-module/config.sh` to set your preferences:

```bash
# FRP config file path
FRP_CONFIG="/data/local/tmp/frpc.ini"

# Mode: "client" or "server"
FRP_MODE="client"
```

## Usage

1. Place your FRP configuration file at the path specified in `config.sh` (default: `/data/local/tmp/frpc.ini`).
2. Reboot your device or manually start the service.
3. FRP will start automatically on boot.

## Checking for Updates

Run the update script to check for new versions:

```
/data/adb/modules/frp-module/update.sh
```

## Example Config

For client mode (`frpc.ini`):

```
[common]
server_addr = your.server.ip
server_port = 7000

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000
```

## License

This project is licensed under the MIT License.