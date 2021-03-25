#----------challange/RDS.tf-------------


resource "aws_db_instance" "GoGreen" {
  allocated_storage                   = "20"
  storage_type                        = "gp2"
  engine                              = "mysql"
  engine_version                      = "8.0.20"
  instance_class                      = "db.t2.micro"
  name                                = "mydb"
  username                            = "team3"
  password                            = "password"
  parameter_group_name                = "default.mysql8.0"
  storage_encrypted                   = false # free tier doesnt support encryption at rest
  availability_zone                   = "us-west-1b"
  backup_retention_period             = 7
  backup_window                       = "21:00-23:50"
  copy_tags_to_snapshot               = true
  enabled_cloudwatch_logs_exports     = ["error", "general"]
  iam_database_authentication_enabled = true
  #kms_key_id                          = "arn:aws:kms:us-west-1:889473501810:key/98c0efcc-8839-41f2-abef-fbf21d6b7dc1"
  maintenance_window = "Mon:01:00-Mon:03:50"
  port               = "3306"
  #final_snapshot_identifier           = "erase-me"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group.id
  vpc_security_group_ids = [aws_security_group.default.id]
  tags = {
    Name = "GoGreen Data Base"
  }
}

resource "aws_db_subnet_group" "rds-subnet-group" {
  name       = "main"
  subnet_ids = [module.vpc.private-subnet-RDS-id, module.vpc.private-subnet-RDS-2-id]

  tags = {
    Name = "My DB subnet group"
  }
}



resource "aws_security_group" "default" {
  name        = "main_rds_sg"
  description = "Allow all inbound traffic"
  vpc_id      = module.vpc.vpc-id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "TCP"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "TCP"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "TCP"
    security_groups = [aws_security_group.web-tier-sg.id]
  }
  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "TCP"
    security_groups = [aws_security_group.app-tier-sg.id]
  }
  tags = {
    Name = "RDS allow web tier"
  }
}
