# [variable block reference](https://developer.hashicorp.com/terraform/language/block/variable)

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

output "cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = aws_iam_role.cluster.arn
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
