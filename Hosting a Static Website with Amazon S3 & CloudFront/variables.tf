variable "bucket_name" {
  default = "mylearning-tfawsdayfourteen-taskbucket-2026"
}


# Allowed instance type
variable "allowed_instance_type" {
  description = "List of Allowed virtual Instances type"
  type        = list(string)
  default     = ["t3.micro", "t3.small", "t3.medium"]
}

# Terraform data source used to automatically fetch information about the AWS region currently targeted by your AWS provider
# This is a Dynamic LookUp
data "aws_region" "current" {}

variable "allowed_regions" {
  description = "Set of allowed AWS regions for resource deployment"
  type        = list(string)
  default     = ["us-east-1", "us-west-1", "eu-west-1", "eu-west-1"]
}

variable "tags" {
  type = map(string)
  default = {
    Name       = "day10"
    created_by = "terraform"
    created_on = "2026-06-03"
  }
}

variable "tags_sets_s3" {
  type = map(string)
  default = {
    Name       = "day14_task_sets_names_for_s3"
    created_by = "terraform"
    created_on = "2026-06-03"
  }
}

variable "tags_condition_s3" {
  type = map(string)
  default = {
    Name        = "day14_task_post_condition_s3"
    Environment = "test"
    created_by  = "terraform"
    created_on  = "2026-06-03"
    Compliance  = "yes"
  }
}

variable "environment" {
  default = "dev"
  type    = string

  # Task 4
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "tagstls" {
  type = map(string)
  default = {
    Name       = "allow_tls"
    created_by = "terraform"
    created_on = "Day14_task"
  }
}

variable "config_type_object" {
  type = object({
    region              = string,
    monitoring_enabled  = bool,
    number_of_instances = number
  })
  default = {
    region              = "us-east-1",
    monitoring_enabled  = true,
    number_of_instances = 1
  }
}

# Variable for instance count timestamp 
variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
}


variable "bucket_names_list" {
  description = "List of s3 bucket names to create"
  type        = list(string)
  default     = ["mytask-bucket-day14", "day14buckettask-02", "taskbucket-day14-03"]
}

variable "bucket_names_set" {
  description = "List of s3 bucket names to create"
  type        = set(string)
  default     = ["01bucket-set-day14", "02-day14bucket-set"]
}

variable "ingress_rules" {
  description = "List of ingress rules for security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS"
  }]
}
