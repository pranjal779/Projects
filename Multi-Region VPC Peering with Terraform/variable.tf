## Variables for Regions

# Primary Region
variable "primary" {
  type        = string
  description = "Region setup for us-east-1"
  default     = "us-east-1"
}

# Secondary Region
variable "secondary" {
  type        = string
  description = "Region setup for us-west-1"
  default     = "us-west-1"
}

# Third Region
variable "third" {
  type        = string
  description = "Region setup for us-east-2"
  default     = "us-east-2"
}


## Variables for VPC CIDR

# Primary VPC -> for Primary Region
variable "primary_vpc_cidr" {
  type        = string
  description = "CIDR block for the primary VPC - us-east-1"
  default     = "10.0.0.0/16"
}

# Secondary VPC -> for Primary Region
variable "secondary_vpc_cidr" {
  type        = string
  description = "CIDR block for the secondary VPC - us-west-1"
  default     = "10.1.0.0/16"
}

# Third VPC -> for Third Region
variable "third_vpc_cidr" {
  type        = string
  description = "CIDR block for the third VPC - us-east-2"
  default     = "10.2.0.0/16"
}

## Variables for Subnet Cidr

# primary subnet cidr: region = us-east-1
variable "primary_subnet_cidr" {
  type        = string
  description = "CIDR Block for primary region subnet"
  default     = "10.0.1.0/28"
}

# secondary subnet cidr: region = us-west-1
variable "secondary_subnet_cidr" {
  type        = string
  description = "CIDR Block for secondary region subnet"
  default     = "10.1.1.0/28"
}

# third subnet cidr: region = us-east-2
variable "third_subnet_cidr" {
  type        = string
  description = "CIDR Block for secondary region subnet"
  default     = "10.2.1.0/28"
}


## Variable for EC2 Instances setup
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}


## Naming the SSH Key Pair for each VPC instance in respective region

# primary region
variable "primary_key_name" {
  description = "Name of the SSH Key pair for the Primary VPC Instance region: us-east-1"
  type        = string
  default     = ""
}

# secondary region
variable "secondary_key_name" {
  description = "Name of the SSH Key pair for the Secondary VPC Instance region: us-west-1"
  type        = string
  default     = ""
}

# third region
variable "third_key_name" {
  description = "Name of the SSH Key pair for the Third VPC Instance region: us-east-2"
  type        = string
  default     = ""
}
