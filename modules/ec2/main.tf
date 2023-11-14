
resource "aws_instance" "main" {
  count                  = length(var.subnet_id)
  ami                    = var.ec2_instance_ami
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = var.subnet_id[count.index]
  iam_instance_profile = var.instance_profile == "" ? null : var.instance_profile
  tags = {
    Name = var.ec2_instance_name
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y awscli
              echo "Hello, this is a test file." > /tmp/testfile.txt
              aws s3 cp /tmp/testfile.txt s3://my-s3-bucket-uo1331iou1/
              EOF
}


resource "aws_security_group" "sg" {
  name        = "tf_sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}