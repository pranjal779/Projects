data "aws_caller_identity" "day16" {}


## 8:53
output "account_id" {
  value = data.aws_caller_identity.day16
}


## 22:35 I have written day16 the instructor has written as name
