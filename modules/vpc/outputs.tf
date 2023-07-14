
# Output definitions

output "vpc_id" {
  description = "vpc_id"
  value       = aws_vpc.luis-vpc.id
}

output "public_subnet1" {
  description = "public subnet1 id"
  value       = aws_subnet.luis-private1.id
}

output "public_subnet2" {
  description = "public subnet2 id"
  value       = aws_subnet.luis-private1.id
}

output "private_subnet1" {
  description = "private subnet1 id"
  value       = aws_subnet.luis-private1.id
}

output "private_subnet2" {
  description = "private subnet2 id"
  value       = aws_subnet.luis-private2.id
}
