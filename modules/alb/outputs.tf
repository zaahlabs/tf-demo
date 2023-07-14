# outputs

output "alb_dns" {
  value = aws_alb.challenge-alb.dns_name
}
