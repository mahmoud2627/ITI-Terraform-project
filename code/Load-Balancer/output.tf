
output "alb_private_dns" {
  value = aws_lb.private_alb.dns_name
}

output "nlb_public_dns" {
  value = aws_lb.public_nlb.dns_name
}

