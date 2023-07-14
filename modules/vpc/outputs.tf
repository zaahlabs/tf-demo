
# Output definitions

output "vpc_id" {
  description = "vpc_id"
  value       = aws_vpc.challenge-vpc.id
}

output "public_subnet1" {
  description = "public subnet1 id"
  value       = aws_subnet.challenge-private1.id
}

output "public_subnet2" {
  description = "public subnet2 id"
  value       = aws_subnet.challenge-private1.id
}

output "private_subnet1" {
  description = "private subnet1 id"
  value       = aws_subnet.challenge-private1.id
}

output "private_subnet2" {
  description = "private subnet2 id"
  value       = aws_subnet.challenge-private2.id
}

output "nat_gateway1" {
  description = "nat gateway1"
  value       = aws_nat_gateway.challenge-natgw1.id
}

output "nat_gateway2" {
  description = "nat gateway2"
  value       = aws_nat_gateway.challenge-natgw2.id
}
