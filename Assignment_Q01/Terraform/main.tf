locals {
  global_tags = {
    Task = "assignmentq01"
  }
}


module "ec2" {
  source    = "./modules/ec2"
  instance_type = var.instance_type
  jenkins_ami   = var.jenkins_ami
  sonarqube_ami = var.sonarqube_ami
  app_ami   = var.app_ami
  vpc_id             = var.vpc_id
  private_subnet_id  = var.private_subnet_id
}
