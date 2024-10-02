output "pub_sub1_id" {
  value = aws_subnet.public["pubSub1"].id
}

output "pub_sub2_id" {
  value = aws_subnet.public["pubSub2"].id
}

output "priv_sub1_id" {
  value = aws_subnet.private["privSub1"].id
}

output "priv_sub2_id" {
  value = aws_subnet.private["privSub2"].id
}
