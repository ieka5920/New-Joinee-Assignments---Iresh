variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
}


variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "jenkins_ami" {
  description = "AMI ID for Jenkins server"
  type        = string
}

variable "sonarqube_ami" {
  description = "AMI ID for SonarQube server"
  type        = string
}

variable "app_ami" {
  description = "AMI ID for app server"
  type        = string
}


variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_id" {
  description = "The ID of the private subnet"
  type        = string
}