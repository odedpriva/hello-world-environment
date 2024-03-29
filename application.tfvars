application = {

  vpc = {

    name = "application"
    cidr = "10.0.0.0/16"

    azs             = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets  = ["10.0.101.0/28", "10.0.102.0/28", "10.0.103.0/28"]

    enable_nat_gateway     = true
    single_nat_gateway     = true
    one_nat_gateway_per_az = false

    enable_vpn_gateway = false

  }

  eks = {

    cluster_name = "application"

    worker_group_instance_type = "t2.medium"
    worker_group_asg_max_size  = 1

  }

}
