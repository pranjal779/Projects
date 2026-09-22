# 6:32 - 7:56
# [csvdecode Function](https://developer.hashicorp.com/terraform/language/functions/csvdecode)
locals {
  users = csvdecode(file("users.csv"))
}

