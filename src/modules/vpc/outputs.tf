output "kk_vpc_id" {
  description       = "VPC ID"
  value             = aws_vpc.kkVPC.id
}

output "kk_public_subnets" {
  description       = "Will be used by Web Server Module to set subnet_ids"
  value             = [
    aws_subnet.kkPublicSubnet1,
    aws_subnet.kkPublicSubnet2
  ]
}

output "kk_private_subnets" {
  description       = "Will be used by RDS Module to set subnet_ids"
  value             = [
    aws_subnet.kkPrivateSubnet1,
    aws_subnet.kkPrivateSubnet2
  ]
}