# Welcome to the ITI-Terraform project wiki!

![1727120256255](https://github.com/user-attachments/assets/f8b0943d-0135-4921-ad2f-173f230433a7)






## Project Description
This Terraform setup provisions a highly available web application infrastructure within AWS, using EC2 instances distributed across multiple availability zones and using NLB in front of the NGINX proxy servers to distribute incoming traffic evenly across both public subnets and ALB in front of the APACHE web servers for distributing traffic to the private web servers.

## Applied Concepts
1. Work on the "dev" workspace.
2. erraform Modules.
3. Remote bucket for state file.
4. DynamoDB State Locking.
5. Datasource to get the image ID for ec2.
6. dynamic Blocks
7. for_each Meta-Argument
8. Remote-exec provisioner to install Apache or proxy in the machines.
9. Local-exec provisioner to print all the machine's ip to a file "all-ips.txt".
10. File provisioner to transfer "index.html" to the private ec2s.


## VPC (Virtual Private Cloud)


A VPC (10.0.0.0/16) is created to isolate the network resources for our application.
The VPC contains both public and private subnets across two availability zones (us-east-1a and us-east-1b) for high availability.
## Load Balancers
Network Load Balancer (NLB):


The NLB handles incoming traffic at the transport layer (TCP/UDP) and distributes it across the NGINX proxy servers in the public subnets. The NLB is optimized for handling high volumes of low-latency traffic.
Public access to the infrastructure starts through the NLB endpoint ([http://public-nlb-***.amazonaws.com](http://public-nlb-%2A%2A%2A.amazonaws.com/)).
Application Load Balancer (ALB):


The ALB operates at the application layer (HTTP) and balances traffic between the NGINX proxies in the public subnets. It is configured for path-based routing, and sticky sessions.
The ALB forwards traffic to the appropriate proxy server based on the application layer requests.
Remote bucket for state file on "dev" workspace


# terraform Modules
1. VPC Module: To create VPC, IGW, Public RT, Private RT, NAT Gatway, Public SG, and Private SG.
2. Subnet Module: To create Public Subnets and Private Subnets.
3. Ec2 Module: To create EC2 instances in the public subnets that run NGINX and EC2 instances in the private subnets running Apache.
4. Loadbalancer Module: To create Network Load Balancer (NLB) and Application Load Balancer (ALB)

## DynamoDB State Locking


A VPC (10.0.0.0/16) is created to isolate the network resources for our application.
The VPC contains both public and private subnets across two availability zones (us-east-1a and us-east-1b) for high availability.
