locals {
  common-tags = {
    terraform   = "true"
    environment = var.environment
  }
  tags = merge(local.common-tags, {})

  tags-asg = [
    {
      key                 = "terraform"
      value               = "true"
      propagate_at_launch = true
    },
    {
      key                 = "environment"
      value               = var.environment
      propagate_at_launch = true
    }
  ]
}
