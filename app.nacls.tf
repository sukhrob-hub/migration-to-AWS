# for the purpose fo creating local code, added a VPC data:

#data "aws_vpc" "current-vpc" {
#  id = var.vpc_id
#}

resource "aws_network_acl" "app-tier-nacl" {
  vpc_id     = module.vpc.vpc-id
  subnet_ids = module.vpc.private-subnet-ids

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }


  tags = {
    Name = "app-tier-acl"
  }
}
