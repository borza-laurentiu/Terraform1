output "EC2_IP" {
    value = aws_instance.TestMachine.private_ip
}

output "SG_ID" {
    value = aws_security_group.sgPublic.id
}