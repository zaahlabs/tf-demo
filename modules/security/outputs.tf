# outputs

output "sg_instance1" {
  value = aws_security_group.challenge-sg-instance1.id
}

output "sg_instance2" {
  value = aws_security_group.challenge-sg-instance2.id
}

output "sg_alb" {
  value = aws_security_group.challenge-sg-alb.id
}

output "sg_vpce1" {
  value = aws_security_group.challenge-sg-vpce-az1.id
}

output "sg_vpce2" {
  value = aws_security_group.challenge-sg-vpce-az2.id
}
