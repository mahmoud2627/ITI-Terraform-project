# ITI-Terraform-project

Project Description
This Terraform setup provisions a highly available web application infrastructure within AWS, using EC2 instances distributed across multiple availability zones. Using NLB in front of the NGINX proxy servers to distribute incoming traffic evenly across both public subnets,and ALB in front of the APACHE web servers for distributing traffic to the private web servers .

Applied Concepts
Work on "dev" workspace.
Terraform Modules.
Remote bucket for statefile.
DynamoDB State Locking.
Datasource to get the image id for ec2.
dynamic Blocks
for_each Meta-Argument
Remote-exec provisioner to install apache or proxy in the machines.
Local-exec provisioner to print all the machines ip to a file "all-ips.txt".
File provisioner to transfer "index.html" to the private ec2s.
