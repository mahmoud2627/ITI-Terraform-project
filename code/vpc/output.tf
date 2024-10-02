
output "myvpc_id" {
  value = aws_vpc.vpc1.id
}

output "pub_sg_id" {
  value = aws_security_group.pub_sg.id
}

output "priv_sg_id" {
  value = aws_security_group.priv_sg.id
}
