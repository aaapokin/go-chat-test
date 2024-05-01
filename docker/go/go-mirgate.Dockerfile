FROM golang:1.22.2

RUN go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
RUN ln -s /go/bin/linux_amd64/migrate /usr/local/bin/migrate

WORKDIR /app