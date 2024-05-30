resource "aws_route53_zone" "neonsign" {
  name = "neonsignsforgit.com"
}

resource "aws_route53_record" "NS" {
  zone_id = aws_route53_zone.neonsign.zone_id
  name    = "neonsignsforgit.com"
  type    = "NS"
  ttl     = 172800
  records = [
    "ns-1907.awsdns-46.co.uk.",
    "ns-566.awsdns-06.net.",
    "ns-150.awsdns-18.com.",
    "ns-1236.awsdns-26.org."
  ]
}

resource "aws_route53_record" "main_A" {
  zone_id = aws_route53_zone.neonsign.zone_id
  name    = "neonsignsforgit.com"
  type    = "A"
  ttl     = 300
  records = [aws_eip.this.public_ip]
}
