
resource "aws_db_instance" "database" {
  allocated_storage = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  engine_version    = var.engine_version
  backup_retention_period = 7
  multi_az          = var.multi_az
  db_name           = var.db_name
  identifier        = "database-${var.environment}"
  username          = var.rds_db_username
  password          = var.rds_db_password
  instance_class    = var.instance_class
  engine            = var.db_engine
  skip_final_snapshot = true
#  final_snapshot_identifier = "mydb-bk"
  storage_encrypted = true
  publicly_accessible = false
#  deletion_protection = true 
  vpc_security_group_ids = [aws_security_group.database-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  monitoring_interval = 30
  monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn

  backup_window = "00:00-02:00"
  maintenance_window = "Sun:03:00-Sun:04:00"
  copy_tags_to_snapshot = true

  tags = {
    environment = var.environment
    Terraform = "true"
    Name = "${var.environment}-Main_DB"
  }
}

resource "aws_db_instance" "database-replica" {
  replicate_source_db         = aws_db_instance.database.identifier
  auto_minor_version_upgrade  = false
  identifier                  = "replica-${var.environment}"
  backup_retention_period = 0
  allocated_storage           = var.allocated_storage
  instance_class              = var.replica_instance_class
  skip_final_snapshot         = true
  vpc_security_group_ids      = [aws_security_group.database-sg.id]
  performance_insights_enabled = true
  performance_insights_retention_period = 7
#  db_subnet_group_name        = aws_db_subnet_group.rds_subnets.name
  multi_az = var.replica_multi_az
  publicly_accessible = false
  depends_on = [ aws_db_instance.database ]

  tags = {
    environment = var.environment
    Terraform = "true"
    Name = "${var.environment}-Replica_DB"

}

}