REGISTRY_NAME = zdnscloud
IMAGE_Name = lvmd
IMAGE_VERSION = v0.5

.PHONY: all container

proto/lvm.pb.go: proto/lvm.proto
	cd proto && protoc -I/usr/local/include -I. --go_out=plugins=grpc:. lvm.proto

all: container

container: 
	docker build -t $(REGISTRY_NAME)/$(IMAGE_Name):$(IMAGE_VERSION) ./ --no-cache
