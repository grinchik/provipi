# provipi

`provipi` (**provi**sioning **pi**) is a tool for automated Raspberry Pi 5 provisioning:

* Downloading the Ubuntu image
* Flashing a microSD card
* Applying a custom cloud-init configuration

For most users, the official [Raspberry Pi Imager](https://github.com/raspberrypi/rpi-imager) is the recommended way to set up a Raspberry Pi.

However, I prefer to avoid installing extra software, so **provipi** automates Raspberry Pi 5 provisioning using only macOS built-in tools.


## Prerequisites

macOS built-in tools:
* `make`
* `curl`
* `diskutil`
* `rsync`
* `dd`
* `osascript`
* `envsubst`
* `gunzip`


## Usage

`SSH_PUBLIC_KEY_FILEPATH` specifies the SSH public key to be used for login.

`DISK_FILEPATH` specifies the disk you want to image.

⚠️ **WARNING:** This operation will completely overwrite the target disk. Make sure you have selected the correct device to avoid data loss.

```sh
sudo make \
    SSH_PUBLIC_KEY_FILEPATH=~/.ssh/id_ed25519.pub \
    DISK_FILEPATH=/dev/diskX
```

Replace `/dev/diskX` with the actual path to your target disk. Use `diskutil list` to identify the correct device.


### Cleaning up

```sh
make clean
```
