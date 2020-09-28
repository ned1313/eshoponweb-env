resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "${terraform.workspace}-docdb-cluster-${count.index}"
  cluster_identifier = aws_docdb_cluster.default.id
  instance_class     = "db.r5.large"
  
}

resource "aws_docdb_cluster" "default" {
  cluster_identifier = "${terraform.workspace}-docdb-cluster"
  master_username    = "employer"
  master_password    = "dakjf87683rbjdvs98djh"
  db_subnet_group_name = aws_docdb_subnet_group.default.name
  deletion_protection = false
  skip_final_snapshot     = true
  vpc_security_group_ids = [aws_security_group.docdb_sg.id]
}

resource "aws_docdb_subnet_group" "default" {
  name       = "${terraform.workspace}-docdb"
  subnet_ids = module.vpc.public_subnets

  tags = {
  }
}

output "docdb-endpoint" {
  value = aws_docdb_cluster.default.endpoint
}