resource "aws_cloudfront_distribution" "frontend" {
  origin {
    domain_name = var.s3_website_endpoint
    origin_id   = "s3-website-origin"

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port             = 80
      https_port            = 443
      origin_ssl_protocols  = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-website-origin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}