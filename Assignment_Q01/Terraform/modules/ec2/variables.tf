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
  description = "AMI ID for App server"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the instances"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for the instances"
  type        = string
}
