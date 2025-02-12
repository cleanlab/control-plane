resource "aws_route53_zone" "posthog-reverse-proxy" {
  name = "${var.posthog_reverse_proxy_subdomain}.${var.domain}"
  comment = "PostHog Reverse Proxy"

  tags = {
    Environment = var.environment
  }
}

resource "aws_acm_certificate" "posthog-reverse-proxy" {
  domain_name = "${var.posthog_reverse_proxy_subdomain}.${var.domain}"
  validation_method = "DNS"

  tags = {
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "posthog-reverse-proxy" {
  zone_id = aws_route53_zone.posthog-reverse-proxy.zone_id
  name = tolist(aws_acm_certificate.posthog-reverse-proxy.domain_validation_options)[0].resource_record_name
  type = tolist(aws_acm_certificate.posthog-reverse-proxy.domain_validation_options)[0].resource_record_type
  ttl = 300
  records = [tolist(aws_acm_certificate.posthog-reverse-proxy.domain_validation_options)[0].resource_record_value]
}

resource "aws_route53_zone" "metronome-reverse-proxy" {
  name = "${var.metronome_reverse_proxy_subdomain}.${var.domain}"
  comment = "Metronome Reverse Proxy"

  tags = {
    Environment = var.environment
  }
}

resource "aws_acm_certificate" "metronome-reverse-proxy" {
  domain_name = "${var.metronome_reverse_proxy_subdomain}.${var.domain}"
  validation_method = "DNS"

  tags = {
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "metronome-reverse-proxy" {
  zone_id = aws_route53_zone.metronome-reverse-proxy.zone_id
  name = tolist(aws_acm_certificate.metronome-reverse-proxy.domain_validation_options)[0].resource_record_name
  type = tolist(aws_acm_certificate.metronome-reverse-proxy.domain_validation_options)[0].resource_record_type
  ttl = 300
  records = [tolist(aws_acm_certificate.metronome-reverse-proxy.domain_validation_options)[0].resource_record_value]
}