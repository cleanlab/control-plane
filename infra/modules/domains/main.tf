resource "aws_route53_zone" "posthog-reverse-proxy" {
  name = "${var.posthog_reverse_proxy_subdomain}.${var.domain}"
  comment = "PostHog Reverse Proxy"

  tags = {
    Environment = var.environment
  }
}

resource "aws_route53_zone" "metronome-reverse-proxy" {
  name = "${var.metronome_reverse_proxy_subdomain}.${var.domain}"
  comment = "Metronome Reverse Proxy"

  tags = {
    Environment = var.environment
  }
}
