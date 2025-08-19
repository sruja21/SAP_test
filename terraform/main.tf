# --- main.tf content from earlier ---
provider "aws" {
  region = var.region
}

resource "aws_db_instance" "app_db" {
  allocated_storage      = var.db_allocated_storage
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [var.db_sg_id]
  db_subnet_group_name   = var.db_subnet_group
  skip_final_snapshot    = true
}

output "db_endpoint" {
  value = aws_db_instance.app_db.endpoint
}

