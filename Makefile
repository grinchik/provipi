# https://ubuntu.com/download/raspberry-pi
IMAGE_URL = https://cdimage.ubuntu.com/releases/24.04.2/release/ubuntu-24.04.2-preinstalled-server-arm64+raspi.img.xz

IMAGE_FILENAME_COMPRESSED = $(notdir $(IMAGE_URL))
IMAGE_FILENAME = $(basename $(IMAGE_FILENAME_COMPRESSED))

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

.PHONY: clean
clean: \
	/
	rm \
		-f \
		"$(IMAGE_FILENAME_COMPRESSED)" \
		"$(IMAGE_FILENAME)" \
		"$(USER_DATA_FILEPATH)" \
		;
