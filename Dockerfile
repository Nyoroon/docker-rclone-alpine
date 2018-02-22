FROM golang:alpine as builder

ENV PROJECT=github.com/ncw/rclone \
    TAG=v1.39

RUN apk add --no-cache git binutils

RUN mkdir -p $GOPATH/src/$(dirname $PROJECT)
RUN git clone https://$PROJECT.git $GOPATH/src/$PROJECT
RUN git -C $GOPATH/src/$PROJECT reset --hard $TAG

RUN go install $PROJECT
RUN strip -s $GOPATH/bin/$(basename $PROJECT)

FROM alpine

COPY --from=builder /go/bin/rclone /usr/local/bin/
