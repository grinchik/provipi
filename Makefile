# https://ubuntu.com/download/raspberry-pi
IMAGE_URL = https://cdimage.ubuntu.com/releases/24.04.3/release/ubuntu-24.04.3-preinstalled-server-arm64+raspi.img.xz

DIRECT_NETWORK = 192.168.3.0/24
DIRECT_INTERFACE_IP = 192.168.3.100/24

IMAGE_FILENAME_COMPRESSED = $(notdir $(IMAGE_URL))
IMAGE_FILENAME = $(basename $(IMAGE_FILENAME_COMPRESSED))
USER_DATA_TEMPLATE_FILEPATH = src/user-data.template.yaml
USER_DATA_FILEPATH = system-boot/user-data
NETWORK_CONFIG_TEMPLATE_FILEPATH = src/network-config.template.yaml
NETWORK_CONFIG_FILEPATH = system-boot/network-config
MOUNT_FILEPATH = /Volumes/system-boot/

.PHONY: _
_: \
	$(IMAGE_FILENAME) \
	$(USER_DATA_FILEPATH) \
	$(NETWORK_CONFIG_FILEPATH) \
	confirm \
	unmount \
	flash \
	sync \
	copy \
	sync \
	unmount \
	notify \
	/

$(IMAGE_FILENAME_COMPRESSED): \
	/
	curl \
		--output \
			"$(IMAGE_FILENAME_COMPRESSED)" \
		"$(IMAGE_URL)" \
		;

$(IMAGE_FILENAME): \
	$(IMAGE_FILENAME_COMPRESSED) \
	/
	gunzip \
		--suffix \
			.xz \
		--keep \
		--verbose \
		--force \
		"$(IMAGE_FILENAME_COMPRESSED)" \
		;

$(USER_DATA_FILEPATH): \
	$(SSH_PUBLIC_KEY_FILEPATH) \
	$(USER_DATA_TEMPLATE_FILEPATH) \
	/
	SSH_PUBLIC_KEY="$(shell cat $(SSH_PUBLIC_KEY_FILEPATH))" \
	DIRECT_NETWORK="$(DIRECT_NETWORK)" \
		envsubst \
			< "$(USER_DATA_TEMPLATE_FILEPATH)" \
			> "$(USER_DATA_FILEPATH)" \
		;

$(NETWORK_CONFIG_FILEPATH): \
	$(NETWORK_CONFIG_TEMPLATE_FILEPATH) \
	/
	DIRECT_INTERFACE_IP="$(DIRECT_INTERFACE_IP)" \
		envsubst \
			< "$(NETWORK_CONFIG_TEMPLATE_FILEPATH)" \
			> "$(NETWORK_CONFIG_FILEPATH)" \
	;

.PHONY: disk-list
disk-list: \
	/
	@diskutil \
		list \
			"$(DISK_FILEPATH)" \
		;

.PHONY: confirm
confirm: \
	disk-list \
	/
	@CONFIRMATION_KEY="YES"; \
	echo "Type $$CONFIRMATION_KEY to continue:"; \
	read LINE; \
	if [ "$$LINE" != "$$CONFIRMATION_KEY" ]; then exit 1; fi

.PHONY: unmount
unmount: \
	/
	diskutil \
		unmountDisk \
			"$(DISK_FILEPATH)" \
		;

.PHONY: flash
flash: \
	/
	ls \
		-l \
			"$(IMAGE_FILENAME)" \
		;

	dd \
		if="$(IMAGE_FILENAME)" \
		of="$(DISK_FILEPATH)" \
		status=progress \
		bs=4m \
		;

.PHONY: sync
sync: \
	/
	sync;
	sleep 3;

.PHONY: copy
copy: \
	/
	rsync \
		--archive \
		--verbose \
		--exclude=".gitignore" \
		--exclude=".DS_Store" \
		"$(dir $(USER_DATA_FILEPATH))" \
		"$(MOUNT_FILEPATH)" \
		;

.PHONY: notify
notify: \
	/
	osascript \
		-e \
			beep \
		;

.PHONY: clean
clean: \
	/
	rm \
		-f \
		"$(IMAGE_FILENAME_COMPRESSED)" \
		"$(IMAGE_FILENAME)" \
		"$(USER_DATA_FILEPATH)" \
		;
