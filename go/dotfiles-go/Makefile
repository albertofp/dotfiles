APP_NAME = dotfiles-go
BINPATH =${HOME}/.local/bin/${APP_NAME}
UNAME := $(shell uname)

.PHONY: build, run, test, clean, all, vet
build: clean
	echo "Building ${APP_NAME} for ${UNAME}..."
	@mkdir -p $(dir ${BINPATH})
	go build -o ${BINPATH} main.go
	echo "Done."

run:
	@go run main.go
test:
	@go test -v ./...
clean:
	@go clean

vet:	
	@go vet ./...

lint:
	@golangci-lint run --enable-all

all: build vet test
