output "EC2_IP" {
    value = aws_instance.TestMachine.private_ip
}

output "SG_ID" {
    value = aws_security_group.sgPublic.id
}

# output "private_subnet_1" {
#     value = aws_subnet.subprivate1.id
# }

# output "private_subnet_2" {
#     value = aws_subnet.subprivate2.id
# }