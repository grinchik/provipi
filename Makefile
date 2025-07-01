# https://ubuntu.com/download/raspberry-pi
IMAGE_URL = https://cdimage.ubuntu.com/releases/24.04.2/release/ubuntu-24.04.2-preinstalled-server-arm64+raspi.img.xz

IMAGE_FILENAME_COMPRESSED = $(notdir $(IMAGE_URL))
IMAGE_FILENAME = $(basename $(IMAGE_FILENAME_COMPRESSED))
USER_DATA_TEMPLATE_FILEPATH = src/user-data.template.yaml
USER_DATA_FILEPATH = system-boot/user-data

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
		envsubst \
			< "$(USER_DATA_TEMPLATE_FILEPATH)" \
			> "$(USER_DATA_FILEPATH)" \
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
