# Infra 101 - Lesson 1

## Writing a sample app to deploy

Simple REST API, "Hello World"
Requirements: 
    * Deployed on a server
    * Accessible via HTTP
    * Return "Hello World" as response
    * Deployed in a container

### Languages

Go is ideal because it of the small containers, simple to write.  Python and Javascript as ok too I guess

* Python
* Go
* Javascript

## Cloud

### What?

* Someone else's infrastructure that you can use a part of (usually paid)

### How?

* Can use an UI, CLI or even code to provision or manage resources
* Easily get rid of resources when not needed anymore

### Why?

* Pay-as-you-go
* Reliability
* Scaling
* Security

### Examples: 

    * AWS
    * Azure
    * Google Cloud
    * Hetzner

## Infrastructure as Code

### Problem:

**Scenario 1:** You have something deployed on the Cloud and it's starting to get much more expensive than intended.  You want to get rid of it all ASAP and deal with it later.  It's all very complex.

* How do you make sure everything is in fact gone?
* How do you bring things back online afterwards?  Do you remember all the steps you need to retrace?

**Scenario 2:** You are working in a team of people.  You have a piece of infrastucture that people keep needing new instances of.  But they all are very similar in some ways (example: a server, accounts with permissions etc)

* How do you minimize the amount of manual (and error prone) work?
* How do you ensure everything is as it should?
* Someone fucks up and destryos stuff.  How do you recover?

### Solution: Infrastructure as Code

* *Declarative* language to describe what you want to have
* Keeps a log of the state of your infrastructure
* Can be version controlled!
* Self documenting
* Modularized

Biggest one is [Terraform](https://www.terraform.io/), example code:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
```

## What is containerization?

### Problem: "But it works on my machine!"

-> Ship your whole fucking machine

### Docker

Simple way to build your application in a self contained environment

Biggest one is [Docker](https://www.docker.com/), example code:

```dockerfile
FROM python:3.8-slim
COPY . /code
WORKDIR /code
RUN pip install -r requirements.txt
CMD [ "python", "./main.py" ]
```

-> Builds a container from your code
-> Runs it
-> You can run it on any machine that has Docker installed
-> Easy to deploy, easy to get rid of

## What is CI/CD?

* Make sure you're deploying often so changes are smaller
* Make sure you're deploying in a reliable way

We want to avoid manual work! Make it easy to follow good practices by making this faster and easier to do.  Easiest way to gets started is with Github Actions:

```yaml
name: Docker Image CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: Build the Docker image
      run: docker build . --file Dockerfile --tag my-image-name:$(date +%s)
    - name: Docker Login
      env:
        DOCKER_USER: ${{secrets.DOCKER_USER}}
        DOCKER_PASSWORD: ${{secrets.DOCKER_PASSWORD}}
      run: |
        echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USER" --password-stdin
    - name: Docker Push
      run: docker push my-image-name:$(date +%s)
```

## Exercise:

1. Write a simple REST API
2. Deploy a server with Terraform
3. Containerize your API with Docker
4. Build pipeline to build (and deploy?) your application to your server
