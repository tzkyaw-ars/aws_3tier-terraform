
resource "aws_instance" "bastion" {
  ami = var.aws_ami
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnets[0].id
  vpc_security_group_ids  = [aws_security_group.bastion-sg.id]
  key_name = var.key_name
  user_data = filebase64("bastion.sh")
  associate_public_ip_address = true

  tags = {
    Name  = "bastion-host"
  }
  
}

resource "aws_iam_role" "ssm_role" {
  name = "ssm-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.ssm_role.name
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_launch_template" "front_end" {
  name = "frontend"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 10
      delete_on_termination = true
    }
  }

  instance_type = var.instance_type
  image_id      = var.aws_ami
  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile.name
  }
  
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.front_end-sg.id]
    
  }

  user_data = filebase64 ("web-data.sh")

  depends_on = [
    aws_lb.front_end
  ]
}


resource "aws_launch_template" "back_end" {
  name = "backend"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 10
      delete_on_termination = true
    }
  }

  instance_type = var.instance_type
  image_id      = var.aws_ami
  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile.name
  }  
  
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.back_end-sg.id]
    
  }

  user_data = filebase64 ("app-data.sh")

  depends_on = [
    aws_lb.back_end
  ]
}
