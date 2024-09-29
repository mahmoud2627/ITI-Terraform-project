# Welcome to the ITI-Terraform project wiki!

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
