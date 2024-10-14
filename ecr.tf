#creating ecr repo
resource "aws_ecr_repository" "demo" {
  name = "demo"

}

#create ecs cluster
resource "aws_ecs_cluster" "demo" {
  name = "demo"

}