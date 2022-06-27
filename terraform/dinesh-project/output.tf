## to see the id of default route table
output "route_table" {
    value = aws_vpc.test-vpc.default_route_table_id
  
}

## to see the id of security group
output "security_group_id" {
    value = aws_security_group.test_sg.id
}