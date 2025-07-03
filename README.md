# RPI5 Imager

## Prerequisites
- macOS


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
