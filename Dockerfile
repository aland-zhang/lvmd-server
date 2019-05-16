FROM golang:alpine AS build
  
RUN mkdir -p /go/src/github.com/zdnscloud/lvmd-server
COPY . /go/src/github.com/zdnscloud/lvmd-server

WORKDIR /go/src/github.com/zdnscloud/lvmd-server
RUN CGO_ENABLED=0 GOOS=linux go build -o /lvmd

RUN apk update && apk add lvm2
ADD shell/lvmd.sh /lvmd.sh
RUN chmod 755 /lvmd.sh
RUN chmod 755 /lvmd
ENTRYPOINT ["/bin/sh"]
