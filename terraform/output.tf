output "lb_dns_url" {
  value = aws_lb.front_end.dns_name
}

output "bastion-ip" {
  value  = aws_instance.bastion.public_ip
}