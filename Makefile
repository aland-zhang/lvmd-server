all: grpc

grpc: proto/lvm.pb.go

proto/lvm.pb.go: proto/lvm.proto
	cd proto && protoc -I/usr/local/include -I. --go_out=plugins=grpc:. lvm.proto

clean:
	rm -f proto/lvm.pb.go

.PHONY: all clean
