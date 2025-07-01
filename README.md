# RPI5 Imager

## Prerequisites
- macOS


## Usage

### Getting Ubuntu image

```sh
make ubuntu-24.04.2-preinstalled-server-arm64+raspi.img
```

### Generating system-boot/user-data file

```sh
SSH_PUBLIC_KEY_FILEPATH=~/.ssh/id_ed25519.pub make system-boot/user-data
```

### Cleaning up

```sh
make clean
```
