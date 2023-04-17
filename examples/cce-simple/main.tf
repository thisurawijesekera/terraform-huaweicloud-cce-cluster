provider "huaweicloud" {
  region = "ap-southeast-3"
}

module "vpc" {
  source  = "cloud-labs-infra/vpc/huaweicloud"
  version = "1.0.1"

  name = "dev01"
}

module "cce_cluster" {
  source  = "cloud-labs-infra/cce-cluster/huaweicloud"
  version = "1.0.0"

  name      = "dev01"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets_ids[0]
  delete_all = "true"
}
