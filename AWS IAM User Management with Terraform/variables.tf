variable "environment" {
  default = "dev"
  type    = string
}

# 2nd varible for userName
variable "username" {
  type    = string
  default = "pranjals"
}

# primary region
variable "primary" {
  type    = string # timestamp 
  default = "us-east-1"
}

# secondary region
variable "secondary" {
  type    = string
  default = "us-west-2"
}

# 15:58
variable "primary_vpc_cidr" {
  default = "10.0.0.0/16"
}

# 16:45
variable "secondary_vpc_cidr" {
  default = "10.1.0.0/16"
}

# 38:54 onwards
variable "primary_subnet_cidr" {
  description = "CIDR block for the primary subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "secondary_subnet_cidr" {
  description = "CIDR block for the secondary subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "primary_key_name" {
  description = "Name of the SSH key pair for Primary VPC instance (us-east-1)"
  type        = string
  default     = "" # 39:17
}

variable "secondary_key_name" {
  description = "Name of the SSH key pair for Secondary VPC instance (us-west-2)"
  type        = string
  default     = ""
}
