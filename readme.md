# What this project does? 
This project creates ECS while using Auto Scaling,
ALB connects to ECS instances, instances connects to the RDS,
The RDS is created with using creds from AWS secrets manager, 
The services are scaleable as well as the EC2s.
Implements the best practices for aws terraform.

TLDR - highly available, secure ECS with ASG, ALB & RDS   

# How to run 
```sh
terraform apply -var-file="./enviorments/production.tfvars"
```

You can create your own tfvars file with your values for other workspaces.