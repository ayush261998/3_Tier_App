provider "aws" {
  region = var.aws_region
  shared_credentials_file = "/Users/ayush.meta/.aws/credentials"
  profile = "3tierwebapp"
}

resource "aws_ecr_repository" "ecr-repo" {
  name = "ecr-repo" # Naming my repository
}


resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.database_subnet_a.id, aws_subnet.database_subnet_b.id]

  tags = {
    Name = "My DB subnet group"
  }
}


resource "aws_db_instance" "tierdb" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "tierDB"
  username             = "user"
  password             = "password"
  db_subnet_group_name = aws_db_subnet_group.default.id
}
