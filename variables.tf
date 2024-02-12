variable "region" {
    default = "us-east-1"
}

variable "access_key" {
    description = "my aws access key"
  
}
variable "secret_key" {
    description = "my aws secret key"
  
}

#Networking
variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
