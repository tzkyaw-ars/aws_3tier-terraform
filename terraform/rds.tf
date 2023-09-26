
resource "aws_db_instance" "database" {
  allocated_storage = var.allocated_storage
  engine_version    = var.engine_version
  multi_az          = true
  db_name           = "primary" 
#   identifier        = "database_primary"
  username          = var.rds_db_username
  password          = var.rds_db_password
  instance_class    = var.instance_class
  engine            = var.db_engine
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.database-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnets.name
}

resource "aws_db_instance" "database-replica" {
  replicate_source_db         = "aws_db_instance.database.identifier"
  replica_mode                = "mounted"
  auto_minor_version_upgrade  = false
  backup_retention_period     = 7
  identifier                  = "instance-replica"
  allocated_storage           = var.allocated_storage
  instance_class              = var.instance_class
  skip_final_snapshot         = true
  vpc_security_group_ids      = [aws_security_group.database-sg.id]
  db_subnet_group_name        = aws_db_subnet_group.rds_subnets.name

}