# --------------------------------------------------------------------------------
# 1. Generate random password for RDS instance
# --------------------------------------------------------------------------------
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!-_=+"
  keepers = {
    db_username = var.db_instance_config.username
  }
}

# --------------------------------------------------------------------------------
# 2. Create RDS subnet group
# --------------------------------------------------------------------------------
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-db-subnet-group"
    }
  )
}

# --------------------------------------------------------------------------------
# 3. Create RDS parameter group
# --------------------------------------------------------------------------------
resource "aws_db_parameter_group" "db_parameter_group" {
  name        = "${var.project_name}-${var.environment}-postgresql-pg"
  family      = var.db_instance_config.family
  description = "Parameter group for ${var.project_name} in ${var.environment}."

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-postgresql-pg"
    }
  )
}

# --------------------------------------------------------------------------------
# 4. Postgresql database instance
# --------------------------------------------------------------------------------
resource "aws_db_instance" "db_instance" {
  identifier              = "${var.project_name}-${var.environment}-db"
  allocated_storage       = var.db_instance_config.allocated_storage
  storage_type            = "gp3"
  engine                  = var.db_instance_config.engine
  engine_version          = var.db_instance_config.engine_version
  instance_class          = var.db_instance_config.instance_class
  db_name                 = var.db_instance_config.db_name
  username                = var.db_instance_config.username
  password                = random_password.db_password.result
  port                    = 5432
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [var.rds_sg_id]
  skip_final_snapshot     = var.db_instance_config.skip_final_snapshot
  parameter_group_name    = aws_db_parameter_group.db_parameter_group.name
  multi_az                = var.db_instance_config.multi_az
  backup_retention_period = var.db_instance_config.backup_retention
  deletion_protection     = var.db_instance_config.deletion_protection

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-db"
    }
  )
}

# --------------------------------------------------------------------------------
# 5. Create a secret to store the database credentials in Secrets Manager.
# --------------------------------------------------------------------------------
resource "aws_secretsmanager_secret" "db_secret" {
  name                    = "${var.project_name}/${var.environment}/db-secrets"
  description             = "Database credentials for ${var.project_name} in ${var.environment}."
  recovery_window_in_days = 0
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-postgres-credentials"
    }
  )
}

# --------------------------------------------------------------------------------
# 6. Create a secret version to store the database credentials in Secrets Manager.
# --------------------------------------------------------------------------------
resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    POSTGRES_USER     = var.db_instance_config.username
    POSTGRES_PASSWORD = random_password.db_password.result
    POSTGRES_DB       = var.db_instance_config.db_name
    POSTGRES_PORT     = "5432"
    DATABASE_URL      = "postgresql+psycopg://${var.db_instance_config.username}:${random_password.db_password.result}@${aws_db_instance.db_instance.address}:5432/${var.db_instance_config.db_name}"
  })
}