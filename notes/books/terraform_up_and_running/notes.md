# Terraform: Up and Running

Code examples: [Github](https://github.com/brikis98/terraform-up-and-running-code)

## Chapter 1: Why Terraform

### What is IaC

Five categories of IaC:

- Ad hoc scripts
  - writing scripts (bash, python etc) to be ran to perform a set of commands
  - Example:
  ```bash
  sudo apt-get update
  sudo apt-get install -y php apache2
  sudo git clone https://github.com/brikis98/php-app.git /var/www/html/app
  sudo service apach2 start
  ```
  - Pros: simple, easy to write
  - Cons: hard to maintain as complexity grows, not standardized
- Configuration management tools
  - Chef, Puppet, Ansible etc
  - Pros over ad hoc scripts:
    - Idempotence: "Can run as many times as you want and it will still produce the expected result"
    - Distribution: easier to manage many remote servers
    - Conventions: enforces structure, file layouts, secrets management etc
- Server templating tools
  - Docker, Packer etc
  - Define state of a server before you deploy
- Orchestration tools
  - Kubernetes (K8s), Amazon ECS, Docker Swarm
  - Deploy VMs and containers
  - Roll out updates
  - Monitor server/container health
  - Scale number of servers/containers in response to load
  - Load balancing (distributing load across machines)
  - Enable networking between containers/VMs
- Provisioning tools
  - Terraform, Pulumi, CloudFormation etc
  - Benefits:
    - Easier automation of the deployment process
    - Speed and safety: much faster than manually running commands, with consistency
    - Documentation: state of the whole infrastructure is documented as code
    - Version Control: IaC allows code to be version controlled just like application code
    - Validation: enables code reviews and automated tests
    - Reuse: define modules to reuse configurations instead of manually recreating infrastructure

### How does Terraform Work?

Terraform is a Go application that compiles to a single binary. It makes API calls on your behalf to a _provider_ like Azure to perform changes to infrastructure in the cloud.

Example terraform code:

```hcl
resource "aws_instance" "example" {
    ami = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
}

resource "google_dns_record_set" "a" {
    name = "demo.google-example.com"
    managed_zone = "example-zone"
    type = "A"
    ttl = 300
    rrdatas = [aws_instance.example.public_ip]
}
```

The code above makes API calls to AWS and provisions a _t2.micro_ EC2 instance with the chosen _ami_ and also creates a DNS entry on GCP pointing to that instance's IP address.

### Configuration Management vs. Provisioning

Generally the approach is to:

1. Use a provisioning tool like Terraform or Pulumi to provision the infrastructure
2. Configure the provisioned infrastructure through the use of a config management tool like Ansible or create a container/image first with all the configuration already in place, then deploy that

### Mutable vs Immutable Infrastructure

2 different paradigms to consider. Essentially:

- Mutable means you use tools to make changes to existing infrastructure after it's deployed
- Immutable means destroying the infrastructure and recreating it with the desired state

Mutable infrastructure can lead to _configuration drift_, meaning that deployed infrastructure accumulates small differences in configuration (especially if done manually) that eventually lead to bugs or just inconsistent behaviour

Terraform follows the immutability paradigm by default, destroying and recreating infra when needed. Though it can be forced to behave differently if needed.

### Procedural vs Declarative Language

Procedural:

- Define steps
- Example: bash script defining lines of code to be executed

Declarative:

- Define desired state
  - Current state is checked against desired state, changes are made so they match
  - Advantages:
    - idempotent
    - readability
    - maintainability
    - reusability

### Chapter 2: Getting Started with Terraform

This book uses AWS for its examples, but the concepts are the same for any other cloud provider aswell. Refer to Terraform documentation for information about other providers.

The first step is authenticating in the shell, so terraform canproperly interface with your cloud provider:

```bash
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

Terraform is written in _HCL_ , a simple declarative language.
Let's start off with a single _main.tf_ file with the following contents:

```hcl
provider "aws" {
    region = "us-east-2"
}
```

For each provider, there are many different _resources_ you can create. For example AWS's EC2 instances or Azure's VMs. They all follow much the same pattern:

```hcl
resource "<PROVIDER>_<TYPE>" "<NAME>" {
    [CONFIG ...]
}
```

The provider type is the exact type of resource you want to create, the name is an identifier of your choosing that you use to refer to this specific resource later on. For example:

```hcl
resource "aws_instance" "example" {
    ami = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
}
```

Every resource has optional and required arguments, refer to the documentation as needed.

To start using terraform to deploy infrastructure, we need to _initialize_ the configuration with `terraform init`. This will figure out what provider you are using and download the necessary dependencies.

By default, it goes into a `.terraform` folder in the current directory (the .terraform folder should be added to your .gitignore). It will also generate a _.terraform.lock.hcl_ file.

Note that it is safe to run the terraform init command multiple times.

With the initialization done, we can _plan_ our deployment.

```bash
terraform plan


      # aws_instance.example will be created
      + resource "aws_instance" "example" {
          + ami                          = "ami-0fb653ca2d3203ac1"
          ...
        }
    Plan: 1 to add, 0 to change, 0 to destroy.
```

Planning does not actually do anything to our deployed infrastructure, it just shows you what _would_ happen if you ran `terraform apply`, which we will do now.

Note that this will always show you the changes and give you a prompt that you have to accept before applying them(can be skipped with a flag for CICD)

There you go, after a few moments the changes should have been applied.

Any further changes follow the same procedure: make changes, _apply_, accept.

**Input Variables**

To make more modular, readable, maintainable code, you can make use of _input variables_

```hcl
variable "example_variable" {
    description = "Optional label you can add to the variable"
    default     = "Optional default value"
    type        = "Optional type constraint"
    validation  = "Optional basic typechecks/value constraints"
    sensitive   = "Optional boolean, value will not be logged when you run apply/plan"
}
```

There's multiple ways to pass a variable:

1. As an option when running plan/apply : `terraform plan -var "example_variable=true`
2. As an environment variable: `export TF_VAR_example_variable=true`

Note that passing it as an argument takes precedence over the environment variable method.

If no value is passed and no default is defined, terraform will interactively prompt for a value.

To reference a variable in your code:

```hcl
resource "aws_security_group" "instance" {
    name = "terraform-example-instance"
    ingress {
        from_port   = var.server_port
        to_port     = var.server_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
```

They can also interpolated like so:

```hcl
user_data = <<-EOF #!/bin/bash
                  echo "Hello, World" > index.html
                  nohup busybox httpd -f -p ${var.server_port} &
                  EOF
```

**Output Variables**

```hcl
output "<NAME>" {
      value = <VALUE>
      [CONFIG ...]
}
```

_Value_ can be any terraform expression.
Output variables accept the same optional _sensitive_ and _description_ parameters, along with _depends_on_, which allows you to explicitely define a dependency.

One possible use case for output variables is to automatically provide the IP address to your server:

```hcl
 output "public_ip" {
      value       = aws_instance.example.public_ip
      description = "The public IP address of the web server"
}
```

The code above is referencing the _public_ip_ attribute of the _example_ EC2 instance.

Note that output variables are also logged to the console when you apply/plan. Additionally, you can run the command `terraform output` to list all outputs without applying any changes, or pass it a specific variable name.

**Data sources**

```hcl
data "<PROVIDER>_<TYPE>" "<NAME>" {
      [CONFIG ...]
}
```

"A data source represents a piece of read-only information that is fetched from the provider (in this case, AWS) every time you run Terraform"

This is useful, for example, to query the API for a list of availability zones so an auto-scaling group of VMs is deployed across them for high availability.

With data sources, the arguments are typically search filters.

### Chapter 3: How to Manage Terraform State

_State_ is how terraform tracks what infrastructure is currently deployed. By default, when you run terraform, it will create a _terraform.tfstate_ file in the same directory. It contains a custom JSON representation of the resources in the "real world".

**Never manually edit the state file**

Problems with local tfstate management:

- Race conditions:
  - If 2 people are applying changes to infrastructure, they have to access the same state file and you can run into race conditions.
    - Most VCS don't provide a way to lock the file that would prevent a race condition
- Shared storage
  - Since people need access to the same file, it needs to be stored in a shared storage
    - Easy to have manual errors (forgetting to pull latest changes, for example)
    - Comitting the state file exposes secrets, it's all plain text
- Isolating state files:

  - If you have multiple environments (staging, production etc) you should isolate the state in different files, which is not possible with local state

  **Solution: remote backend**

  A Terraform "backend" is how Terraform determines how to load and store state. By default this is a local _.tfstate_ file, but the better way is to host this file remotely (such as in Amazon S3, Azure Storage, Google Cloud Storage etc).

  This solves the issues above:

  - Automatically loads the proper, current state whenever you run plan/apply
  - Natively supports locking, preventing race conditions
  - Native support for encryption and fine grained access control
  - Support for versioning

  We will need:

  1. Bucket to store the state file - take steps to lock down access and encrypt in transit and at rest in the bucket (check provider specific docs)
  2. Managed KV Database table to store locks

  We can then configure the backend to use the remote storage:

  ```hcl
  terraform {
    # Check docs for Azure services
    backend "s3" {
      bucket          = "bucket-name"
      key             = "global/s3/terraform.tfstate"
      region          = "north-europe"
      dynamodb_table  = "table-name"
      encrypt         = true
    }
  }
  ```

  Simply run `terraform init` again to make the backend changes take effect.

  Note: the _backend_ block does not support the use of variables

### How to Create Reusable Infrastructure with Terraform Modules
