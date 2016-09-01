all: image

image:
	docker build -t timwolla/knot .

.PHONY: image
