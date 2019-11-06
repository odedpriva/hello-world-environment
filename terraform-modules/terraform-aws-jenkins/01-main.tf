resource "aws_security_group" "jenkins" {
  name   = "jenkins"
  vpc_id = var.vpc_id
  tags   = local.tags
}

resource "aws_launch_configuration" "jenkins_config" {
  name_prefix          = "jenkins"
  image_id             = var.ami_id
  instance_type        = var.atlassian_config["jenkins_ec2_instance_type"]
  security_groups      = [var.security_group]
  user_data            = data.template_file.jenkins-user-data.rendered
  iam_instance_profile = var.iam_profile
  key_name             = var.ssh_key_name
  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "jenkins-user-data" {
  template = file("${path.module}/templates/jenkins-user-data.tpl")
  vars = {
    config_script_64 = base64encode(data.template_file.jenkins-node-config-script.rendered)
    efs_share        = aws_efs_mount_target.jenkins-attachments[0].dns_name
    efs_mount_point  = var.attachments_mount_point
  }
}

data "template_file" "jenkins-node-config-script" {
  template = file("${path.module}/templates/configure-jenkins.sh")
}

resource "aws_autoscaling_group" "jenkins_asg" {
  name                 = "jenkins.${var.environment_type}"
  availability_zones   = [var.availability_zones]
  desired_capacity     = var.desired_size
  max_size             = var.max_size
  min_size             = var.min_size
  launch_configuration = aws_launch_configuration.jenkins_config.id
  vpc_zone_identifier  = [var.private_subnet_ids]
  health_check_type    = "EC2"
  tag {
    key                 = "Name"
    value               = "jenkins.${var.environment_type}"
    propagate_at_launch = true
  }
  tag {
    key                 = "environment_type"
    value               = var.environment_type
    propagate_at_launch = true
  }
  tag {
    key                 = "terraform"
    value               = true
    propagate_at_launch = false
  }
  tag {
    key                 = "role"
    value               = "jenkins"
    propagate_at_launch = true
  }
}

