
# Public IP
output "ec2_global_ips" {
  value = ["${aws_instance.nginx-api_test_vm.*.public_ip}"]
}

# Hostname
output "ec2_hostname" {
  value = aws_instance.nginx-api_test_vm.*.public_dns
}

### Creds
output "login" {
  value = aws_iam_user.nginx-api_user.name
}

# Password
output "password" {
  value = aws_iam_user_login_profile.nginx-api_user.password
}

# Access key
# output "secret_access_key" {
#   value     = aws_iam_access_key.nginx-api_user.id
# }