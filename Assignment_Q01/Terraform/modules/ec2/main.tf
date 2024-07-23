resource "aws_key_pair" "jenkins_sonarqube_key" {
  key_name   = "emid_rsa"
  public_key = file("keys/emid_rsa.pub")
}

resource "aws_instance" "jenkins" {
  ami           = var.jenkins_ami
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  user_data     = file("userdata/jenkins_user_data.sh")
  associate_public_ip_address = true
  key_name      = aws_key_pair.jenkins_sonarqube_key.key_name
  tags = {
    Name = "Jenkins-Server"
  }

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
}

resource "aws_instance" "sonarqube" {
  ami           = var.sonarqube_ami
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  user_data     = file("userdata/sonarqube_user_data.sh")
  key_name      = aws_key_pair.jenkins_sonarqube_key.key_name
  associate_public_ip_address = true
  tags = {
    Name = "SonarQube-Server"
  }

  vpc_security_group_ids = [aws_security_group.sonarqube_sg.id]
}

resource "aws_instance" "app" {
  ami           = var.app_ami
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  user_data     = file("userdata/app_user_data.sh")
  key_name      = aws_key_pair.jenkins_sonarqube_key.key_name
  associate_public_ip_address = true
  tags = {
    Name = "App-Server"
  }

  vpc_security_group_ids = [aws_security_group.app_sg.id]
}

resource "aws_security_group" "jenkins_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sonarqube_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "sonarqube_eip" {
  instance = aws_instance.sonarqube.id
}

resource "aws_eip" "app_eip" {
  instance = aws_instance.app.id
}
