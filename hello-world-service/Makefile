#.PHONY: build build-alpine clean test help default

MAKEFILE_VERSION = "0.1.0"

PROJECT_ROOT_DIR = $(shell git rev-parse --show-toplevel)
PROJECT_ROOT_DIR_BAENAME=$(shell basename "${PROJECT_ROOT_DIR}" )
MAIN_FILE=main.go

BIN_NAME=${PROJECT_ROOT_DIR_BAENAME}
BUILD_DIR=build
BIN_DIR := ${GOPATH}/bin
VERSION_FILE := ${PROJECT_ROOT_DIR}/VERSION

GOLANGCI_LINT := $(BIN_DIR)/golangci-lint
GOLANGCI_LINT_VERSION := "v1.16.0"

VERSION := $(shell head -n 1 ${VERSION_FILE})
GIT_COMMIT=$(shell git rev-parse HEAD)
GIT_DIRTY=$(shell test -n "`git status --porcelain`" && echo "+DIRTY" || true)
BUILD_DATE=$(shell date '+%Y-%m-%d-%H:%M:%S')
PLATFORMS := windows linux darwin
os = $(word 1, $@)

DOCKER_HUB_ORGANIZATION_NAME = "luminate"
CONTAINER_IMAGE_NAME := "${DOCKER_HUB_ORGANIZATION_NAME}/${BIN_NAME}"

default: help

help:
	@echo
	@echo 'Management commands for ${BIN_NAME} package:'
	@echo
	@echo 'Usage:'
	@echo ''
	@echo 'Basic commands:'
	@echo ''
	@echo '    make tests                       Run local tests.'
	@echo '    make tests-integration           Run integration tests.'
	@echo '    make get-deps                    Gettign dependencies.'
	@echo '    make clean                       Clean the directory tree.'
	@echo '    make lint                        Runs golangci-lint.'
	@echo '    make version                     Displays the version for use in other tools.'
	@echo '    make vet                         Runs vet.'
	@echo '    make run                         Runs go run main.go.'
	@echo ''
	@echo 'For docker packaging:'
	@echo ''
	@echo '    make package         Build final docker image with just the go binary inside'
	@echo '    make build-alpine    Compile optimized for alpine linux.'
	@echo '    make tag             Tag image created by package with latest, git commit and version'
	@echo '    make push            Push tagged images to registry'
	@echo

build-message:
	@echo "building ${BIN_NAME} ${VERSION}"
	@echo "GOPATH=${GOPATH}"
	@echo "GIT_COMMIT=${GIT_COMMIT}"
	@echo "GIT_DIRTY=${GIT_DIRTY}"

$(PLATFORMS):
	GOOS=$(os) GOARCH=amd64 go build -ldflags "-X ${PROJECT_ROOT_DIR_BAENAME}/commandLineController.GitCommit=${GIT_COMMIT}${GIT_DIRTY} -X ${PROJECT_ROOT_DIR_BAENAME}/cmd.BuildDate=${BUILD_DATE}" -o build/$(os)/amd64/${BIN_NAME} ${MAIN_FILE}
	@if [ $(os) = "windows" ]; then mv -v build/$(os)/amd64/${BIN_NAME} build/$(os)/amd64/${BIN_NAME}.exe; fi

get-deps:
	@echo "go get ./..."
	go get ./...

build-alpine:
	@echo "building ${BIN_NAME} ${VERSION}"
	@echo "GOPATH=${GOPATH}"
	go build -ldflags '-w -linkmode external -extldflags "-static" -X ${PROJECT_ROOT_DIR_BAENAME}/commandLineController.GitCommit=${GIT_COMMIT}${GIT_DIRTY} -X ${PROJECT_ROOT_DIR_BAENAME}/cmd.BuildDate=${BUILD_DATE}' -o bin/${BIN_NAME} ${MAIN_FILE}

package:
	@echo "building image ${BIN_NAME} ${VERSION} $(GIT_COMMIT)"
	docker build --build-arg VERSION=${VERSION} --build-arg GIT_COMMIT=$(GIT_COMMIT) -t $(IMAGE_NAME):local .

tag:
	@echo "Tagging: latest ${VERSION} $(GIT_COMMIT)"
	docker tag $(IMAGE_NAME):local $(IMAGE_NAME):$(GIT_COMMIT)
	docker tag $(IMAGE_NAME):local $(IMAGE_NAME):${VERSION}
	docker tag $(IMAGE_NAME):local $(IMAGE_NAME):latest

push: tag
	@echo "Pushing docker image to registry: latest ${VERSION} $(GIT_COMMIT)"
	docker push $(IMAGE_NAME):$(GIT_COMMIT)
	docker push $(IMAGE_NAME):${VERSION}
	docker push $(IMAGE_NAME):latest

clean:
	@echo "cleaning ${BUILD_DIR} direcotry "
	@test ! -e build || rm -rf build

tests:
	@echo "testing using go test, excluding integration-tests"
	go test --race `go list ./... | grep -v integration-tests`

tests-integration:
	@echo "testing integration-tests package"
	go test --race `go list ./... | grep integration-tests`

.PHONY:
$(GOLANGCI_LINT):
	@echo "downloading golangci-lint to $(BIN_DIR)/golangci-lint "
	$(shell curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | /usr/bin/env BINARY=golangci-lint sh -s -- -b ${BIN_DIR} ${GOLANGCI_LINT_VERSION})

lint: $(GOLANGCI_LINT)
	@echo "running golangci-lint run"
	golangci-lint --verbose run

version:
	@echo "${VERSION}"

run:
	@echo "running go run ${MAIN_FILE}"
	go run ${MAIN_FILE}

vet:
	@echo "running go vet"
	go vet
