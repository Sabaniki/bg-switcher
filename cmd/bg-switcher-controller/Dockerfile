FROM golang:1.17 as builder
WORKDIR /workspace
COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download
COPY cmd/bg-switcher-controller/main.go main.go
COPY api/ api/
COPY pkg/ pkg/
COPY cmd/ cmd/
COPY controllers/ controllers/
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on \
  go build -o ./cmd/bg-switcher-controller/bin/bg-switcher-controller ./cmd/bg-switcher-controller

FROM ubuntu:latest
RUN apt-get update && apt-get install -y jq iproute2 sudo
COPY --from=builder /workspace/cmd/bg-switcher-controller/bin/bg-switcher-controller /usr/bin/bg-switcher-controller
