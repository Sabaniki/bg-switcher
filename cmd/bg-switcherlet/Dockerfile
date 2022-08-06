FROM golang:1.17 as builder

WORKDIR /workspace

# Install kubectl
RUN ["curl", "-LO", "https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl"]
RUN ["chmod", "+x", "./kubectl"]
RUN ["mv", "./kubectl", "/usr/local/bin/kubectl"]

# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
COPY cmd/bg-switcherlet/main.go main.go
COPY api/ api/
COPY controllers controllers
COPY pkg/ pkg/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o manager main.go

# FROM ubuntu:20.04
FROM sabaniki/docker-in-docker:latest

WORKDIR /
COPY --from=builder /workspace/manager .
COPY --from=builder /usr/local/bin/kubectl /usr/local/bin/kubectl
USER 65532:65532

WORKDIR /workspace
ENTRYPOINT ["/manager"]
