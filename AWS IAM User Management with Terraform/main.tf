# 12:33
# [Resource: aws_iam_user](https://registry.terraform.io/providers/hashicorp/aws/2.43.0/docs/resources/iam_user)
resource "aws_iam_user" "users" {
  for_each = { for user in local.users : user.first_name => user }

  name = lower("${substr(each.value.first_name, 0, 1)}${each.value.last_name}")
  path = "/users/"

  tags = {
    "DisplayName" = "${each.value.first_name} ${each.value.last_name}"
    "Department"  = each.value.department
    "JobTitle"    = each.value.job_title
  }

}


# 21:44
# [Resource: aws_iam_user_login_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_login_profile)
resource "aws_iam_user_login_profile" "users" {
  for_each = aws_iam_user.users

  # as per instructor user = each.value.name
  user                    = each.value.name # check error file planoutput 3, I had mistakenly added here day16 from the data.tf instead of name, which resulted in an error correct result at line 600
  password_reset_required = true

  # lifecycle rule so anyone cannot change the requirements
  lifecycle {
    ignore_changes = [password_reset_required, password_length]
  }
}
