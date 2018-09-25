# devops-project

Built by Tim Kidd - https://www.linkedin.com/in/timothykidd/

This project utilizes Terraform and Chef to run an auto scaling, secure, low cost "Hello World" website in AWS. Note: This guide is high level.

## Features

- All infrastructure to run the demo site lives in code and is built automatically except for foundational pieces such as the demo SSL cert and demo domain registrar's nameserver settings, etc.

- All machine configuration is managed in code via Chef Manage. As the website scales (new nodes built by AWS according to templates built by Terraform) all new nodes immediately check in to Chef for configuration of the machine. Chef runs every 30 minutes via scheduled task to ensure machine config doesn't drift over the life of the machine due to manual changes to machine.

- The Application Load Balancer redirects all HTTP requests to HTTPS

- SSL offload happens in the ALB, and all traffic hitting the web servers is HTTP.

- All node(s) running the demo website are AWS spot instances, greatly reducing the price to run the infrastructure.

- As the CPU average of the pool breaches 70%, an appropriate number of new machines are automatically spun up to take the load. The reverse is also true as the load dies down. minimum is 1, max is 3 machines. As new nodes are added to the load balancer, they will not serve traffic until they are responding with 200s to HTTP requests.

## Planned Enhancements:

- Further tune warm up/ cool down numbers in EC2 resource pools to be more efficient
- Deploy/ manage website code via AWS Code Deploy
- Build Cloudwatch monitors on tkidd.tk's site content to ensure scaling activities are smooth for clients
- Lint cookbook via Chef Automate's Rubocop

## Getting Started

Clone entire repo and then set up IaC tools

### Prerequisites

Set up Terraform - https://www.terraform.io/intro/getting-started/install.html
Set up a free Managed Chef Server (up to 5 nodes) - https://manage.chef.io/signup

## Running the demo

Once Terraform is installed, build up the demo environment:
```
terraform init
terraform plan
terraform apply
```
Browse to site tkidd.tk (or whatever domain you have decided to use)

Peg the CPU on the running instance and watch new nodes spin up and add to pool by running the CPU Burn-in .exe on the desktop for 15 minutes on both cores (run two instances). Refresh the website and watch the instance IDs flip back and forth as you hit both instances with your browser. Nodes will automatically terminate once CPU test completes.
```

```

### Running Chef's Rspec unit tests

Tests the functionality of some of the individual operations of the Chef cookbook(s). Not all tests currently work due to the chef-client not being found unless attribute overridden which breaks the chef run on the client.

```
cd chef-repo/cookbooks/hello_world
chef exec rspec
```

### And coding style tests

Chef Automate would lint the cookbooks via RuboCop, but has not been used in the project yet.

```

```

## Built With

* [Terraform](https://www.terraform.io/) - IaC tool
* [Chef](https://www.chef.io/) - System configuration/ DSC tool

## Authors

Tim Kidd - https://www.linkedin.com/in/timothykidd/
