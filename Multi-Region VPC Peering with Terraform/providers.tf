terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"

    }
  }
}

# Configure the AWS Provider from the documentation

# First region for us-east-1
provider "aws" {
  region = var.primary
  alias  = "primary"
}

# Second region for us-west-1
provider "aws" {
  region = var.secondary
  alias  = "secondary"
}

# Third region for us-east-2
provider "aws" {
  region = var.third
  alias  = "third"
}
