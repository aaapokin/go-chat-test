FROM golang:1.22.2

RUN apt-get update && apt-get install -y curl && apt-get install -y unzip

ENV PROTOC_ZIP=protoc-26.1-linux-x86_64.zip
ENV GOBIN=/usr/local/bin

#for local development - compilation when saving file
RUN go install github.com/mitranim/gow@latest

#for generate protobuf
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.34.0
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0

##install protoc
ENV PROTOC_ZIP=protoc-26.1-linux-x86_64.zip
RUN curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v26.1/$PROTOC_ZIP
RUN unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
RUN unzip -o $PROTOC_ZIP -d /usr/local 'include/*'
RUN rm -f $PROTOC_ZIP

WORKDIR /app

