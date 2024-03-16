APP_NAME = dotfiles-go
.PHONY: build, run, test, clean, all, vet
build: clean
	GOARCH=amd64 GOOS=darwin go build -o ${APP_NAME}-darwin main.go
	GOARCH=amd64 GOOS=linux go build -o ${APP_NAME}-linux main.go
run:
	@go run main.go
test:
	@go test -v ./...
clean:
	@go clean
	@rm -f ${APP_NAME}-linux
	@rm -f ${APP_NAME}-darwin

vet:	
	@go vet ./...

lint:
	@golangci-lint run --enable-all

all: build vet test
