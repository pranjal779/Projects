resource "aws_s3_bucket" "taskbucket" {
  bucket = var.bucket_name
  # Task 4
  # bucket = "${var.environment}-${var.bucket_name}"
}


# Iimplicit Dependency on the Resources
resource "aws_s3_bucket_public_access_block" "task_block" {
  bucket = aws_s3_bucket.taskbucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "origin" {
  name                              = "demo-origin-pranj-day14"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket     = aws_s3_bucket.taskbucket.id
  depends_on = [aws_s3_bucket_public_access_block.task_block]

  # https://awspolicygen.s3.amazonaws.com/policygen.html

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowCloudFrontGetObject",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.taskbucket.arn}/*"
        "Condition" = {
          "StringEquals" = {
            "AWS:SourceArn" = "${aws_cloudfront_distribution.s3_distribution.arn}"
          }
        }
      }
    ]
  })
}


# upload static files
resource "aws_s3_object" "object" {

  for_each = fileset("${path.module}/www", "**/*")
  bucket   = aws_s3_bucket.taskbucket.id

  key    = each.value
  source = "${path.module}/www/${each.value}"

  etag = filemd5("${path.module}/www/${each.value}")

  # lookup function
  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "json" = "application/json",
    "png"  = "image/png"
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg",
    "gif"  = "image/gif",
    "svg"  = "image/svg+xml",
    "ico"  = "image/x-icon",
    "text" = "text/plain"

  }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")

}

# [Resource: aws_cloudfront_distribution](https://registry.terraform.io/providers/hashicorp/aws/2.43.0/docs/resources/cloudfront_distribution)
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.taskbucket.bucket_regional_domain_name
    origin_id                = "S3-${aws_s3_bucket.taskbucket.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.origin.id # latest way to access
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  # will get 
  # │ Error: creating CloudFront Distribution: operation error CloudFront: CreateDistributionWithTags, https response error StatusCode: 403,
  # check the applyOutput log Line 336 - 355
  # logging_config {
  #   include_cookies = false
  #   bucket          = aws_s3_bucket.taskbucket.bucket_regional_domain_name
  #   prefix          = "myprefix"
  # }

  # Default Cache behavior
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.taskbucket.id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    # Task 5-d
    # Header policy
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers.id
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # tags = {
  #   Environment = "production"
  # }

  # Task 4
  tags = {
    Environment = var.environment
  }

  viewer_certificate {
    # for task 1 and 2 use this one:
    cloudfront_default_certificate = true #### this is old way

    # Reuired a real domian that you need to own
    # acm_certificate_arn = data.aws_acm_certificate.my_domain.arn
    # ssl_support_method  = "sni-only"
    # otherwise you will get 
    #  terraform apply
    # ╷
    # │ Error: Reference to undeclared resource
    # │ 
    # │   on main.tf line 142, in resource "aws_cloudfront_distribution" "s3_distribution":
    # │  142:     acm_certificate_arn = data.aws_acm_certificate.my_domain.arn
    # │ 
    # │ A data resource "aws_acm_certificate" "my_domain" has not been declared in the root module.
    # ╵
  }

  # Task 5a - Custom Error Pages
  custom_error_response {
    error_code            = 404
    response_code         = 404
    response_page_path    = "/error.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 403
    response_code         = 403
    response_page_path    = "/error.html"
    error_caching_min_ttl = 10
  }
}


# Task 5b - Security Header Policy
# [Resource: aws_cloudfront_response_headers_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_response_headers_policy)
resource "aws_cloudfront_response_headers_policy" "security_headers" {
  name = "day14-security-headers-policy"


  security_headers_config {

    # Prevents clickjacking
    # frame_options → stops your site being embedded in iframes prevents clickjacking attacks
    frame_options {
      frame_option = "DENY"
      override     = true
    }

    # Prevents MIME type sniffing
    # content_type_options → browser must respect declared content type prevents MIME sniffing attacks
    content_type_options {
      override = true
    }

    # Forces HTTPS for 1 year
    # strict_transport_security  → browser always uses HTTPS even if someone types http://
    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains         = true
      override                   = true
    }

    # Controls referrer information
    # referrer_policy → controls what URL info is shared when clicking links to other sites
    referrer_policy {
      referrer_policy = "same-origin"
      override        = true
    }

    # Prevents XSS attacks
    # xss_protection → browser blocks detected XSS attacks cross site scripting protection
    xss_protection {
      mode_block = true
      protection = true
      override   = true
    }
  }
}
