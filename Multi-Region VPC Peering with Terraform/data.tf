# [reference 1 for Data Source for AZ](https://github.com/hashicorp/terraform-provider-aws/blob/main/website/docs/d/availability_zones.html.markdown)
# [reference 2 for Data Source for AZ](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones)
# [Resource: aws_ec2_availability_zone_group](http://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_availability_zone_group)
# [Data Source: aws_availability_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones)
# [Data Source: aws_ami - for owners](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami#example-usage)
# [Data Source: aws_ami_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami_ids)
# [Resource: aws_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ami)

## Data Source for VPC Peering Task

# Data source to get available AZs in Primary Region
data "aws_availability_zones" "primary" {
  provider = aws.primary
  state    = "available"
}

# Data source to get available AZs in Secondary region
data "aws_availability_zones" "secondary" {
  provider = aws.secondary
  state    = "available"
}

# Data source to get available AZs in Third region
data "aws_availability_zones" "third" {
  provider = aws.third
  state    = "available"
}


# [Data Source: aws_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)
## Data source for Primary region AMI (Ubuntu 24.04 LTS)
### canonical ubuntu owner IDs are same across all regions
data "aws_ami" "primary_ami" {
  provider    = aws.primary
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

## Data source for Secondary region AMI (Ubuntu 24.04 LTS)
data "aws_ami" "secondary_ami" {
  provider    = aws.secondary
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


## Data source for Third region AMI (Ubuntu 24.04 LTS)
data "aws_ami" "third_ami" {
  provider    = aws.third
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
