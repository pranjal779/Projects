```hcl
# old was to access s3 origin
s3_origin_config {
  origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
}


# new way to access s3 origin
# ✅ New way - references your OAC resource
origin_access_control_id = aws_cloudfront_origin_access_control.origin.id

```
