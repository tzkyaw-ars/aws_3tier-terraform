
resource "aws_db_instance" "database" {
  allocated_storage = var.allocated_storage
  engine_version    = var.engine_version
  backup_retention_period = 7
  multi_az          = var.multi_az
  db_name           = var.db_name
  identifier        = "database"
  username          = var.rds_db_username
  password          = var.rds_db_password
  instance_class    = var.instance_class
  engine            = var.db_engine
  skip_final_snapshot = true
#  final_snapshot_identifier = "mydb-bk"
  vpc_security_group_ids = [aws_security_group.database-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name
#  performance_insights_enabled = true

  backup_window = "00:00-02:00"
  maintenance_window = "Sun:03:00-Sun:04:00"
  copy_tags_to_snapshot = true
}

resource "aws_db_instance" "database-replica" {
  replicate_source_db         = aws_db_instance.database.identifier
  auto_minor_version_upgrade  = false
  identifier                  = "replica"
  backup_retention_period = 0
  allocated_storage           = var.allocated_storage
  instance_class              = var.instance_class
  skip_final_snapshot         = true
  vpc_security_group_ids      = [aws_security_group.database-sg.id]
#  performance_insights_enabled = true
#  db_subnet_group_name        = aws_db_subnet_group.rds_subnets.name
  multi_az = var.multi_az
  depends_on = [ aws_db_instance.database ]

}