resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "${var.name}-docdb-cluster-${count.index}"
  cluster_identifier = aws_docdb_cluster.default.id
  instance_class     = "db.r5.large"
  
}

resource "aws_docdb_cluster" "default" {
  cluster_identifier = "${var.name}-docdb-cluster"
  availability_zones = slice(data.aws_availability_zones.azs.names, 0, 2)
  master_username    = "employer"
  master_password    = "dakjf87683rbjdvs98djh"
  db_subnet_group_name = aws_docdb_subnet_group.default.name
  deletion_protection = false
}

resource "aws_docdb_subnet_group" "default" {
  name       = "${var.name}-docdb"
  subnet_ids = module.vpc.public_subnets

  tags = {
  }
}