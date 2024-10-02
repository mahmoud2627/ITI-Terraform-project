output "nginx1_id" {
  value = aws_instance.nginx["proxy_1"].id
}

output "nginx2_id" {
  value = aws_instance.nginx["proxy_2"].id
}

output "web1_id" {
  value = aws_instance.web["web1"].id
}

output "web2_id" {
  value = aws_instance.web["web2"].id
}
