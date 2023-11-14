module "tf_vpc" {
  source = "./modules/vpc"
}
module "tf_ec2" {
  source    = "./modules/ec2"
  vpc_id    = module.tf_vpc.vpc_id
  subnet_id = module.tf_vpc.pub_sub_id
  instance_profile = module.role.instance_role_name
  backet_name = module.s3.bucket_name
}
module "tf_LB" {
  source      = "./modules/loadbalancer"
  subnets     = module.tf_vpc.pub_sub_id
  sg_id       = module.tf_ec2.sg_id
  vpc_id      = module.tf_vpc.vpc_id
  instance_id = module.tf_ec2.ec2_id
  subnet_id = module.tf_vpc.pub_sub_id
  
}
module "role" {
  source = "./modules/iam"

  role_name = "MyEC2InstanceRole"
  policy_actions = [ "s3:*" ]
  policy_effect = "Allow"
  policy_resources = [module.s3.bucket_arn, "${module.s3.bucket_arn}/*"]
}
module "s3" {
  source = "./modules/s3"

  bucket_name = "my-s3-bucket-uo1331iou1"
  bucket_encryption_enabled = true
}