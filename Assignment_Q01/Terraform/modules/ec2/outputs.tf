output "jenkins_instance_id" {
  value = aws_instance.jenkins.id
}

output "sonarqube_instance_id" {
  value = aws_instance.sonarqube.id
}

output "app_instance_id" {
  value = aws_instance.app.id
}
