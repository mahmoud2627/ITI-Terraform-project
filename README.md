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

![vpc](https://github.com/user-attachments/assets/16771421-ca05-4c92-b7e6-c9c228d43fbb)

A VPC (10.0.0.0/16) is created to isolate the network resources for our application.
The VPC contains both public and private subnets across two availability zones (us-east-1a and us-east-1b) for high availability.
## Load Balancers
Network Load Balancer (NLB):

![lb1](https://github.com/user-attachments/assets/e70d5183-9821-46f7-9f5b-ab386f1d9359)



The NLB handles incoming traffic at the transport layer (TCP/UDP) and distributes it across the NGINX proxy servers in the public subnets. The NLB is optimized for handling high volumes of low-latency traffic.
Public access to the infrastructure starts through the NLB endpoint ([http://public-nlb-***.amazonaws.com](http://public-nlb-%2A%2A%2A.amazonaws.com/)).
Application Load Balancer (ALB):

![lb2](https://github.com/user-attachments/assets/6ed6bbcf-9c35-4628-9cb1-924bf47600aa)



The ALB operates at the application layer (HTTP) and balances traffic between the NGINX proxies in the public subnets. It is configured for path-based routing, and sticky sessions.
The ALB forwards traffic to the appropriate proxy server based on the application layer requests.
Remote bucket for state file on "dev" workspace


# terraform Modules
1. VPC Module: To create VPC, IGW, Public RT, Private RT, NAT Gatway, Public SG, and Private SG.
2. Subnet Module: To create Public Subnets and Private Subnets.
3. Ec2 Module: To create EC2 instances in the public subnets that run NGINX and EC2 instances in the private subnets running Apache.
4. Loadbalancer Module: To create Network Load Balancer (NLB) and Application Load Balancer (ALB)


## Remote bucket for statefile:

![s3](https://github.com/user-attachments/assets/3d71c801-b96e-441c-a6bb-5ac655c4f512)



## DynamoDB State Locking
![db](https://github.com/user-attachments/assets/3905dd74-d465-42ee-a2a1-c619edffb93d)


## Terraform Apply Result:

![apply](https://github.com/user-attachments/assets/3febff3f-23a8-434a-b489-f931cc45c77b)

## Accessing the DNS:
![Screenshot 2024-09-29 213833](https://github.com/user-attachments/assets/7b0e7780-ac1c-4c8c-b137-69c45bd3d702)
![Screenshot 2024-09-29 214033](https://github.com/user-attachments/assets/60576bc3-e273-4f62-8807-9437aa0ee6fb)


## Terraform Destroy:

![des](https://github.com/user-attachments/assets/dedda469-f758-4dae-b82d-a306e052193b)




