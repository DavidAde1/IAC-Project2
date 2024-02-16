# INTRODUCTION
### Hello everyone, and welcome to the part 2 of my IAC-Project.You can check [here](https://github.com/DavidAde1/IAC-Project1) for part 1 to take a read.
## The objective of this project is simple but a little bit advanced: Provisioning a load balancer to our AWS infrastructure and exposing a simple HTML page that specify the hostname of the instance responding in our infrastructure. We will also make use of ASG(Auto Scaling Group) and instance template in this project. Do not panic,we've got this under control.

## What is ALB?
An Application Load Balancer (ALB) is a type of load balancer provided by Amazon Web Services (AWS) that helps distribute incoming traffic to multiple targets, such as EC2 instances or containers, within an Amazon Virtual Private Cloud (VPC).

ALBs operate at the application layer (Layer 7) of the OSI model, meaning they can direct traffic based on specific rules, such as the content of the request, rather than just the IP address and port. This makes ALBs well-suited for handling HTTP and HTTPS traffic, as they can route requests to different backend services based on factors like the URL path, hostname, or query parameters.

Overall, ALBs are a powerful and flexible tool for managing application traffic within an AWS environment, and are an important component of many modern cloud-based architectures.

## What is AWS ASG?
AWS Auto Scaling groups (ASGs) let you easily scale and manage a collection of EC2 instances that run the same instance configuration. You can then manage the number of running instances manually or dynamically, allowing you to lower operating costs.

# PREREQUISITES
1. An AWS Account(IAM user preferably)
2. OpenTofu installed on your local machine. You can follow the guide [here](https://opentofu.org/docs/intro/install/)

## Before we get started with this, i want to endeavor you to check the part 1 above, we will be making some additions and changes from there.Moving on, let's create 3 new files to add to the files from part 1 in our code editor:
**alb.tf**  
**autoscaling.tf**   
**output.tf**   

# Provider
 I didn't make any changes in the **main.tf** file from the part 1. We declared the AWS provider with the desired region,the iam account secret key and access key using a variable.

# Variable 
 Inside the **variables.tf** file i added a new variable called availability_zones to specify the 2 availability zones for our public subnets. we also have the necessary variables for configuration, including the  AWS secret key,AWS access key and AWS region. 

 # Network
  Inside the **network.tf** file we will create our VPC and subnet resources. In the previous project, we used just a single default subnet with just 1 availability zone but in this project we will create 2 subnets with an availability zone attched to each of them.

# Security
Inside the **security.tf** we will be creating 2 security groups for this project.We are creating for the load balancer and the vpc network.So we will also add this line of code in the ingress block for our vpc security group to allow inbound access to from the ALB only.
'security_groups = [aws_security_group.load-balancer.id]' 





