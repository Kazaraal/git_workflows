resource "aws_db_subnet_group" "kkDBSubnetGroup" {
  name                      = "kk-db-subnet-group"
  subnet_ids                = [
    var.kk_private_subnets[0].id,
    var.kk_private_subnets[1].id
  ]

  tags                      = {
    Name                    = "kkDBSubnetGroup"
    Project                 = "kk_tf_demo"
  }
}

resource "aws_security_group" "kkDBSecurityGroup" {
  name                      = "kkDBSecurityGroup"
  vpc_id                    = var.vpc_id

  tags                      = {
    Name                    = "kkDBSecurityGroup"
    Project                 = "kk_tf_demo"
  }
}

resource "aws_security_group_rule" "kkdb_ingress_rule" {
  security_group_id         = aws_security_group.kkDBSecurityGroup.id  
  type                      = "ingress"
  from_port                 = 5432
  to_port                   = 5432
  protocol                  = "tcp"
  cidr_blocks               = [
    var.private_subnet_cidrs[0],
    var.private_subnet_cidrs[1]
  ]
}

resource "aws_db_instance" "kkRDS" {
  db_name                   = var.db_name
  availability_zone         = var.db_az
  db_subnet_group_name      = aws_db_subnet_group.kkDBSubnetGroup.name
  vpc_security_group_ids    = [aws_security_group.kkDBSecurityGroup.id]
  allocated_storage         = 20
  storage_type              = "standard"
  engine                    = "postgres"    #aws rds describe-db-engine-versions --query "DBEngineVersions[].Engine" --output text | sort -u
  engine_version            = "17.5"        # aws rds describe-db-engine-versions --engine postgres --query "DBEngineVersions[].EngineVersion"
  instance_class            = "db.m5.large"
  username                  = var.db_username
  password                  = var.db_user_password
  skip_final_snapshot       = true

  tags                      = {
    Name                    = "kkRDS"
    Project                 = "kk_tf_demo"
  }
}