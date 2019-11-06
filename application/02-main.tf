module "vpc" {
  source = "../terraform-modules/terraform-aws-vpc"

  name = var.application.vpc["name"]
  cidr = var.application.vpc["cidr"]

  azs             = var.application.vpc["azs"]
  private_subnets = var.application.vpc["private_subnets"]
  public_subnets  = var.application.vpc["public_subnets"]

  enable_nat_gateway     = var.application.vpc["enable_nat_gateway"]
  single_nat_gateway     = var.application.vpc["single_nat_gateway"]
  one_nat_gateway_per_az = var.application.vpc["one_nat_gateway_per_az"]

  enable_vpn_gateway = var.application.vpc["enable_vpn_gateway"]

  tags = local.tags
}

module "cluster" {
  source       = "../terraform-modules/terraform-aws-eks"
  cluster_name = var.application.eks.cluster_name
  vpc_id       = module.vpc.vpc_id
  subnets      = module.vpc.private_subnets

  worker_groups = [
    {
      instance_type = var.application.eks.worker_group_instance_type
      asg_max_size  = var.application.eks.worker_group_asg_max_size
      tags          = local.tags-asg
    }
  ]

  tags = local.tags
}

/* vpc module output
azs	A list of availability zones specified as argument to this module
database_network_acl_id	ID of the database network ACL
database_route_table_ids	List of IDs of database route tables
database_subnet_arns	List of ARNs of database subnets
database_subnet_group	ID of database subnet group
database_subnets	List of IDs of database subnets
database_subnets_cidr_blocks	List of cidr_blocks of database subnets
database_subnets_ipv6_cidr_blocks	List of IPv6 cidr_blocks of database subnets in an IPv6 enabled VPC
default_network_acl_id	The ID of the default network ACL
default_route_table_id	The ID of the default route table
default_security_group_id	The ID of the security group created by default on VPC creation
default_vpc_cidr_block	The CIDR block of the VPC
default_vpc_default_network_acl_id	The ID of the default network ACL
default_vpc_default_route_table_id	The ID of the default route table
default_vpc_default_security_group_id	The ID of the security group created by default on VPC creation
default_vpc_enable_dns_hostnames	Whether or not the VPC has DNS hostname support
default_vpc_enable_dns_support	Whether or not the VPC has DNS support
default_vpc_id	The ID of the VPC
default_vpc_instance_tenancy	Tenancy of instances spin up within VPC
default_vpc_main_route_table_id	The ID of the main route table associated with this VPC
egress_only_internet_gateway_id	The ID of the egress only Internet Gateway
elasticache_network_acl_id	ID of the elasticache network ACL
elasticache_route_table_ids	List of IDs of elasticache route tables
elasticache_subnet_arns	List of ARNs of elasticache subnets
elasticache_subnet_group	ID of elasticache subnet group
elasticache_subnet_group_name	Name of elasticache subnet group
elasticache_subnets	List of IDs of elasticache subnets
elasticache_subnets_cidr_blocks	List of cidr_blocks of elasticache subnets
elasticache_subnets_ipv6_cidr_blocks	List of IPv6 cidr_blocks of elasticache subnets in an IPv6 enabled VPC
igw_id	The ID of the Internet Gateway
intra_network_acl_id	ID of the intra network ACL
intra_route_table_ids	List of IDs of intra route tables
intra_subnet_arns	List of ARNs of intra subnets
intra_subnets	List of IDs of intra subnets
intra_subnets_cidr_blocks	List of cidr_blocks of intra subnets
intra_subnets_ipv6_cidr_blocks	List of IPv6 cidr_blocks of intra subnets in an IPv6 enabled VPC
name	The name of the VPC specified as argument to this module
nat_ids	List of allocation ID of Elastic IPs created for AWS NAT Gateway
nat_public_ips	List of public Elastic IPs created for AWS NAT Gateway
natgw_ids	List of NAT Gateway IDs
private_network_acl_id	ID of the private network ACL
private_route_table_ids	List of IDs of private route tables
private_subnet_arns	List of ARNs of private subnets
private_subnets	List of IDs of private subnets
private_subnets_cidr_blocks	List of cidr_blocks of private subnets
private_subnets_ipv6_cidr_blocks	List of IPv6 cidr_blocks of private subnets in an IPv6 enabled VPC
public_network_acl_id	ID of the public network ACL
public_route_table_ids	List of IDs of public route tables
public_subnet_arns	List of ARNs of public subnets
public_subnets	List of IDs of public subnets
public_subnets_cidr_blocks	List of cidr_blocks of public subnets
public_subnets_ipv6_cidr_blocks	List of IPv6 cidr_blocks of public subnets in an IPv6 enabled VPC
redshift_network_acl_id	ID of the redshift network ACL
redshift_route_table_ids	List of IDs of redshift route tables
redshift_subnet_arns	List of ARNs of redshift subnets
redshift_subnet_group	ID of redshift subnet group
redshift_subnets	List of IDs of redshift subnets
redshift_subnets_cidr_blocks	List of cidr_blocks of redshift subnets
redshift_subnets_ipv6_cidr_blocks	List of IPv6 cidr_blocks of redshift subnets in an IPv6 enabled VPC
vgw_id	The ID of the VPN Gateway
vpc_arn	The ARN of the VPC
vpc_cidr_block	The CIDR block of the VPC
vpc_enable_dns_hostnames	Whether or not the VPC has DNS hostname support
vpc_enable_dns_support	Whether or not the VPC has DNS support
vpc_endpoint_apigw_dns_entry	The DNS entries for the VPC Endpoint for APIGW.
vpc_endpoint_apigw_id	The ID of VPC endpoint for APIGW
vpc_endpoint_apigw_network_interface_ids	One or more network interfaces for the VPC Endpoint for APIGW.
vpc_endpoint_appmesh_envoy_management_dns_entry	The DNS entries for the VPC Endpoint for AppMesh.
vpc_endpoint_appmesh_envoy_management_id	The ID of VPC endpoint for AppMesh
vpc_endpoint_appmesh_envoy_management_network_interface_ids	One or more network interfaces for the VPC Endpoint for AppMesh.
vpc_endpoint_appstream_dns_entry	The DNS entries for the VPC Endpoint for AppStream.
vpc_endpoint_appstream_id	The ID of VPC endpoint for AppStream
vpc_endpoint_appstream_network_interface_ids	One or more network interfaces for the VPC Endpoint for AppStream.
vpc_endpoint_athena_dns_entry	The DNS entries for the VPC Endpoint for Athena.
vpc_endpoint_athena_id	The ID of VPC endpoint for Athena
vpc_endpoint_athena_network_interface_ids	One or more network interfaces for the VPC Endpoint for Athena.
vpc_endpoint_cloudformation_dns_entry	The DNS entries for the VPC Endpoint for Cloudformation.
vpc_endpoint_cloudformation_id	The ID of VPC endpoint for Cloudformation
vpc_endpoint_cloudformation_network_interface_ids	One or more network interfaces for the VPC Endpoint for Cloudformation.
vpc_endpoint_cloudtrail_dns_entry	The DNS entries for the VPC Endpoint for CloudTrail.
vpc_endpoint_cloudtrail_id	The ID of VPC endpoint for CloudTrail
vpc_endpoint_cloudtrail_network_interface_ids	One or more network interfaces for the VPC Endpoint for CloudTrail.
vpc_endpoint_codebuild_dns_entry	The DNS entries for the VPC Endpoint for codebuild.
vpc_endpoint_codebuild_id	The ID of VPC endpoint for codebuild
vpc_endpoint_codebuild_network_interface_ids	One or more network interfaces for the VPC Endpoint for codebuild.
vpc_endpoint_codecommit_dns_entry	The DNS entries for the VPC Endpoint for codecommit.
vpc_endpoint_codecommit_id	The ID of VPC endpoint for codecommit
vpc_endpoint_codecommit_network_interface_ids	One or more network interfaces for the VPC Endpoint for codecommit.
vpc_endpoint_codepipeline_dns_entry	The DNS entries for the VPC Endpoint for CodePipeline.
vpc_endpoint_codepipeline_id	The ID of VPC endpoint for CodePipeline
vpc_endpoint_codepipeline_network_interface_ids	One or more network interfaces for the VPC Endpoint for CodePipeline.
vpc_endpoint_config_dns_entry	The DNS entries for the VPC Endpoint for config.
vpc_endpoint_config_id	The ID of VPC endpoint for config
vpc_endpoint_config_network_interface_ids	One or more network interfaces for the VPC Endpoint for config.
vpc_endpoint_dynamodb_id	The ID of VPC endpoint for DynamoDB
vpc_endpoint_dynamodb_pl_id	The prefix list for the DynamoDB VPC endpoint.
vpc_endpoint_ec2_dns_entry	The DNS entries for the VPC Endpoint for EC2.
vpc_endpoint_ec2_id	The ID of VPC endpoint for EC2
vpc_endpoint_ec2_network_interface_ids	One or more network interfaces for the VPC Endpoint for EC2
vpc_endpoint_ec2messages_dns_entry	The DNS entries for the VPC Endpoint for EC2MESSAGES.
vpc_endpoint_ec2messages_id	The ID of VPC endpoint for EC2MESSAGES
vpc_endpoint_ec2messages_network_interface_ids	One or more network interfaces for the VPC Endpoint for EC2MESSAGES
vpc_endpoint_ecr_api_dns_entry	The DNS entries for the VPC Endpoint for ECR API.
vpc_endpoint_ecr_api_id	The ID of VPC endpoint for ECR API
vpc_endpoint_ecr_api_network_interface_ids	One or more network interfaces for the VPC Endpoint for ECR API.
vpc_endpoint_ecr_dkr_dns_entry	The DNS entries for the VPC Endpoint for ECR DKR.
vpc_endpoint_ecr_dkr_id	The ID of VPC endpoint for ECR DKR
vpc_endpoint_ecr_dkr_network_interface_ids	One or more network interfaces for the VPC Endpoint for ECR DKR.
vpc_endpoint_ecs_agent_dns_entry	The DNS entries for the VPC Endpoint for ECS Agent.
vpc_endpoint_ecs_agent_id	The ID of VPC endpoint for ECS Agent
vpc_endpoint_ecs_agent_network_interface_ids	One or more network interfaces for the VPC Endpoint for ECS Agent.
vpc_endpoint_ecs_dns_entry	The DNS entries for the VPC Endpoint for ECS.
vpc_endpoint_ecs_id	The ID of VPC endpoint for ECS
vpc_endpoint_ecs_network_interface_ids	One or more network interfaces for the VPC Endpoint for ECS.
vpc_endpoint_ecs_telemetry_dns_entry	The DNS entries for the VPC Endpoint for ECS Telemetry.
vpc_endpoint_ecs_telemetry_id	The ID of VPC endpoint for ECS Telemetry
vpc_endpoint_ecs_telemetry_network_interface_ids	One or more network interfaces for the VPC Endpoint for ECS Telemetry.
vpc_endpoint_elasticloadbalancing_dns_entry	The DNS entries for the VPC Endpoint for Elastic Load Balancing.
vpc_endpoint_elasticloadbalancing_id	The ID of VPC endpoint for Elastic Load Balancing
vpc_endpoint_elasticloadbalancing_network_interface_ids	One or more network interfaces for the VPC Endpoint for Elastic Load Balancing.
vpc_endpoint_events_dns_entry	The DNS entries for the VPC Endpoint for CloudWatch Events.
vpc_endpoint_events_id	The ID of VPC endpoint for CloudWatch Events
vpc_endpoint_events_network_interface_ids	One or more network interfaces for the VPC Endpoint for CloudWatch Events.
vpc_endpoint_git_codecommit_dns_entry	The DNS entries for the VPC Endpoint for git_codecommit.
vpc_endpoint_git_codecommit_id	The ID of VPC endpoint for git_codecommit
vpc_endpoint_git_codecommit_network_interface_ids	One or more network interfaces for the VPC Endpoint for git_codecommit.
vpc_endpoint_glue_dns_entry	The DNS entries for the VPC Endpoint for Glue.
vpc_endpoint_glue_id	The ID of VPC endpoint for Glue
vpc_endpoint_glue_network_interface_ids	One or more network interfaces for the VPC Endpoint for Glue.
vpc_endpoint_kinesis_firehose_dns_entry	The DNS entries for the VPC Endpoint for Kinesis Firehose.
vpc_endpoint_kinesis_firehose_id	The ID of VPC endpoint for Kinesis Firehose
vpc_endpoint_kinesis_firehose_network_interface_ids	One or more network interfaces for the VPC Endpoint for Kinesis Firehose.
vpc_endpoint_kinesis_streams_dns_entry	The DNS entries for the VPC Endpoint for Kinesis Streams.
vpc_endpoint_kinesis_streams_id	The ID of VPC endpoint for Kinesis Streams
vpc_endpoint_kinesis_streams_network_interface_ids	One or more network interfaces for the VPC Endpoint for Kinesis Streams.
vpc_endpoint_kms_dns_entry	The DNS entries for the VPC Endpoint for KMS.
vpc_endpoint_kms_id	The ID of VPC endpoint for KMS
vpc_endpoint_kms_network_interface_ids	One or more network interfaces for the VPC Endpoint for KMS.
vpc_endpoint_logs_dns_entry	The DNS entries for the VPC Endpoint for CloudWatch Logs.
vpc_endpoint_logs_id	The ID of VPC endpoint for CloudWatch Logs
vpc_endpoint_logs_network_interface_ids	One or more network interfaces for the VPC Endpoint for CloudWatch Logs.
vpc_endpoint_monitoring_dns_entry	The DNS entries for the VPC Endpoint for CloudWatch Monitoring.
vpc_endpoint_monitoring_id	The ID of VPC endpoint for CloudWatch Monitoring
vpc_endpoint_monitoring_network_interface_ids	One or more network interfaces for the VPC Endpoint for CloudWatch Monitoring.
vpc_endpoint_rekognition_dns_entry	The DNS entries for the VPC Endpoint for Rekognition.
vpc_endpoint_rekognition_id	The ID of VPC endpoint for Rekognition
vpc_endpoint_rekognition_network_interface_ids	One or more network interfaces for the VPC Endpoint for Rekognition.
vpc_endpoint_s3_id	The ID of VPC endpoint for S3
vpc_endpoint_s3_pl_id	The prefix list for the S3 VPC endpoint.
vpc_endpoint_sagemaker_api_dns_entry	The DNS entries for the VPC Endpoint for SageMaker API.
vpc_endpoint_sagemaker_api_id	The ID of VPC endpoint for SageMaker API
vpc_endpoint_sagemaker_api_network_interface_ids	One or more network interfaces for the VPC Endpoint for SageMaker API.
vpc_endpoint_sagemaker_runtime_dns_entry	The DNS entries for the VPC Endpoint for SageMaker Runtime.
vpc_endpoint_sagemaker_runtime_id	The ID of VPC endpoint for SageMaker Runtime
vpc_endpoint_sagemaker_runtime_network_interface_ids	One or more network interfaces for the VPC Endpoint for SageMaker Runtime.
vpc_endpoint_secretsmanager_dns_entry	The DNS entries for the VPC Endpoint for secretsmanager.
vpc_endpoint_secretsmanager_id	The ID of VPC endpoint for secretsmanager
vpc_endpoint_secretsmanager_network_interface_ids	One or more network interfaces for the VPC Endpoint for secretsmanager.
vpc_endpoint_servicecatalog_dns_entry	The DNS entries for the VPC Endpoint for Service Catalog.
vpc_endpoint_servicecatalog_id	The ID of VPC endpoint for Service Catalog
vpc_endpoint_servicecatalog_network_interface_ids	One or more network interfaces for the VPC Endpoint for Service Catalog.
vpc_endpoint_sns_dns_entry	The DNS entries for the VPC Endpoint for SNS.
vpc_endpoint_sns_id	The ID of VPC endpoint for SNS
vpc_endpoint_sns_network_interface_ids	One or more network interfaces for the VPC Endpoint for SNS.
vpc_endpoint_sqs_dns_entry	The DNS entries for the VPC Endpoint for SQS.
vpc_endpoint_sqs_id	The ID of VPC endpoint for SQS
vpc_endpoint_sqs_network_interface_ids	One or more network interfaces for the VPC Endpoint for SQS.
vpc_endpoint_ssm_dns_entry	The DNS entries for the VPC Endpoint for SSM.
vpc_endpoint_ssm_id	The ID of VPC endpoint for SSM
vpc_endpoint_ssm_network_interface_ids	One or more network interfaces for the VPC Endpoint for SSM.
vpc_endpoint_ssmmessages_dns_entry	The DNS entries for the VPC Endpoint for SSMMESSAGES.
vpc_endpoint_ssmmessages_id	The ID of VPC endpoint for SSMMESSAGES
vpc_endpoint_ssmmessages_network_interface_ids	One or more network interfaces for the VPC Endpoint for SSMMESSAGES.
vpc_endpoint_storagegateway_dns_entry	The DNS entries for the VPC Endpoint for Storage Gateway.
vpc_endpoint_storagegateway_id	The ID of VPC endpoint for Storage Gateway
vpc_endpoint_storagegateway_network_interface_ids	One or more network interfaces for the VPC Endpoint for Storage Gateway.
vpc_endpoint_sts_dns_entry	The DNS entries for the VPC Endpoint for STS.
vpc_endpoint_sts_id	The ID of VPC endpoint for STS
vpc_endpoint_sts_network_interface_ids	One or more network interfaces for the VPC Endpoint for STS.
vpc_endpoint_transfer_dns_entry	The DNS entries for the VPC Endpoint for Transfer.
vpc_endpoint_transfer_id	The ID of VPC endpoint for Transfer
vpc_endpoint_transfer_network_interface_ids	One or more network interfaces for the VPC Endpoint for Transfer.
vpc_endpoint_transferserver_dns_entry	The DNS entries for the VPC Endpoint for transferserver.
vpc_endpoint_transferserver_id	The ID of VPC endpoint for transferserver
vpc_endpoint_transferserver_network_interface_ids	One or more network interfaces for the VPC Endpoint for transferserver
vpc_id	The ID of the VPC
vpc_instance_tenancy	Tenancy of instances spin up within VPC
vpc_ipv6_association_id	The association ID for the IPv6 CIDR block
vpc_ipv6_cidr_block	The IPv6 CIDR block
vpc_main_route_table_id	The ID of the main route table associated with this VPC
vpc_secondary_cidr_blocks	List of secondary CIDR blocks of the VPC
*/


