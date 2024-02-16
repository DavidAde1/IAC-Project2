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

## Before we get started with this, i want to endeavor you to check the part 1 above in the INTRODUCTION SECTION, we will be making some additions and changes from there.Moving on, let's create 3 new files to add to the files from part 1 in our code editor:
**alb.tf**  
**autoscaling.tf**   
**output.tf**   

# Provider
 I didn't make any changes in the **main.tf** file from the part 1. We declared the AWS provider with the desired region,the iam account secret key and access key using a variable.

# Variable 
 Inside the **variables.tf** file, i added a new variable called availability_zones to specify the 2 availability zones for our public subnets. we also have the necessary variables for configuration, including the  AWS secret key,AWS access key and AWS region. 

 # Network
  Inside the **network.tf** file, we will create our VPC and subnet resources. In the previous project, we used just a single default subnet with just 1 availability zone but in this project we will create 2 subnets with an availability zone attched to each of them.

# Security
Inside the **security.tf**, we will be creating 2 security groups for this project.We are creating for the load balancer and the vpc network.So we will also add this line of code in the ingress block for our vpc security group to allow inbound access to from the ALB only.
`security_groups = [aws_security_group.load-balancer.id]`


# Create instance template 
In the **server.tf**, we are going to define a new resource called ```aws_launch_configuration``` instead of the normal```aws_instance``` resource from part 1. A launch configuration specifies the EC2 instance configuration that an ASG will use to launch each new instance.Inside the user_data field, we will add a new line of code to showcase the hostname of the instance responding via the load-balancer.
```
echo "<h1>loading from $(hostname -f)..</h1>" > /var/www/html/index.html
```
# Create Auto Scaling group
ASG allow for dynamic scaling and make it easier to manage a group of instances that host the same services. In the **autoscaling.tf** file, we will create ```aws_autoscaling_group``` resource and define the following in the resource:
    -the minimum and maximum number of instances allowed in the group.
    -the desired count to launch (desired_capacity).
    -the launch configuration to use for each instance in the group.
    -a list of subnets where the ASG will launch new instances

# Create Load Balancer resources for the infrastructure
 The ```aws_lb``` resource creates an application load balancer, which routes traffic at the application layer. In the **alb.tf** file, the load balancer will be associated with the specified subnets and security group, and will be given a tag with the specified key-value pair. We also created 3 other resources that the load balancer resource is dependent on, you can read more about them in the Load balancer resource section [here](https://developer.hashicorp.com/terraform/tutorials/aws/aws-asg)

# Output
The **output.tf** file will output our loadbalancer dns address in the console,so we can check loadbalancer in action and view the hostnames of the instances.

# Conclusion 
## We are finally ready to deploy our infrastructure with OpenTofu which is an open source IAC tool.Use the following commands below:

 **tofu init** to set up the backend for OpenTofu.
You should see this kind of output in your terminal in the image below.
![Tofu init](/images/tofuinit.png)

 **tofu plan** to see what the resources will be created.
You should see this kind of output in your terminal in the image below.
![Tofu plan](/images/tofuplan.png)

**tofu apply** to deploy the environment designed in the code.
You should see this kind of output in your terminal in the image below.
![Tofu apply](/images/tofuapply.png)

## Let's take a look in our AWS console together to confirm our infrastructure was deployed right.
![AWS Console](/images/consolecheck.png)
You can see above in the image that all the resources were created by terraform successfully 

## Lets's also view our load balancer in action and copy the value of the```elb-dns-name``` shown in our terminal 
![ALB Check](/images/ip1.png)
![ALB Check](/images/ip2.png)

### We can see above the index.html file exposed in our browser showing the IPs of the instances responding and receiving requests

### Let's delete our infrastructure using:
**tofu destroy** when you no longer need it.
You can see below it was successfully destroyed
![Terraform Destroy](/images/tofudestroy.png)



