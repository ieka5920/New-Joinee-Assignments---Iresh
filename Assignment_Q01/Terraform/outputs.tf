output "jenkins_instance_id" {
  value = module.ec2.jenkins_instance_id
}

output "sonarqube_instance_id" {
  value = module.ec2.sonarqube_instance_id
}

output "app_instance_id" {
  value = module.ec2.app_instance_id
}
