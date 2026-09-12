🚀 Day 14 of hashtag#30daysofawsterraform Piyush sachdeva

# Hosting a Static Website with Amazon S3 & CloudFront

[<img width="907" height="171" alt="image" src="https://github.com/user-attachments/assets/dc2506d7-9e05-4c99-bf35-1c85d2dc2c0d" />](https://youtu.be/bK6RimAv2nQ?si=FRP50bM6ylX8OHLo)

[LinkedIn Post](https://www.linkedin.com/posts/pranjaldevpy_30daysofawsterraform-activity-7499899516670828546-U8q3?utm_source=share&utm_medium=member_desktop&rcm=ACoAAB-p9moB6BgGmKkXCmELgcNwx08wA3D3hSY)

This hands-on Terraform exercise where I built and deployed a static website using AWS services and managed the infrastructure through Terraform.

⚙️ What I Built:
- Hosted a static website using Amazon S3
- Distributed the website through Amazon CloudFront
- Configured CloudFront Origin Access Control (OAC) with SigV4
- Restricted direct public access to the S3 bucket
- Created an S3 bucket policy allowing CloudFront to retrieve objects
- Automated website file uploads using aws_s3_object and for_each
- Added custom 403 and 404 error pages
- Configured CloudFront security headers

🔐 Security Configuration
I also configured a CloudFront response headers policy with:
- X-Frame-Options
- X-Content-Type-Options
- Strict-Transport-Security
- Referrer-Policy
- X-XSS-Protection

One of the important things I learned was the difference between simply creating an Origin Access Control resource and actually connecting it to the CloudFront distribution.

```hcl
origin_access_control_id = aws_cloudfront_origin_access_control . origin . id
```

This helped me better understand how Terraform resources are connected through references.

🧪 🕵 👨‍🏭 Troubleshooting:
This was also one of the more challenging days so far. I encountered configuration issues while working through CloudFront and learned to troubleshoot them by reading Terraform/AWS error messages, checking the documentation, and comparing the configuration with the expected AWS resource structure.

🧠 Key Takeaway
Today reinforced that Terraform is not only about provisioning individual AWS resources.
The real power comes from combining multiple services and defining their relationships as infrastructure code.

S3 + CloudFront + OAC + IAM/S3 policy + security headers + Terraform gave me a much better understanding of how a complete cloud deployment can be assembled.
