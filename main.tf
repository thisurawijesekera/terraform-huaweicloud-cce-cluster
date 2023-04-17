data "huaweicloud_availability_zones" "zones" {
  region = var.region
}

locals {
  name = var.name_postfix == null ? format("%s-cce", var.name) : format("%s-cce-%s", var.name, var.name_postfix)
}

resource "huaweicloud_cce_cluster" "main" {
  name            = local.name
  region          = var.region
  cluster_version = var.cluster_version
  cluster_type    = var.cluster_type
  description     = var.description
  flavor_id       = var.flavor_id

  vpc_id                 = var.vpc_id
  subnet_id              = var.subnet_id
  container_network_type = var.container_network_type
  container_network_cidr = var.container_network_cidr
  service_network_cidr   = var.service_network_cidr
  eni_subnet_id          = var.eni_subnet_id
  eni_subnet_cidr        = var.eni_subnet_cidr

  authentication_mode              = var.authentication_mode
  authenticating_proxy_ca          = var.authentication_mode == "authenticating_proxy" ? var.authenticating_proxy.ca : null
  authenticating_proxy_cert        = var.authentication_mode == "authenticating_proxy" ? var.authenticating_proxy.cert : null
  authenticating_proxy_private_key = var.authentication_mode == "authenticating_proxy" ? var.authenticating_proxy.private_key : null

  ##
  # Use three availability zones only when using HA flavors, pattern '*.s2.*'
  ##
  dynamic "masters" {
    for_each = length(var.availability_zones) == 0 ? slice(data.huaweicloud_availability_zones.zones.names, 0, can(regex("\\.s2\\.", var.flavor_id)) ? 3 : 1) : slice(var.availability_zones, 0, can(regex("\\.s2\\.", var.flavor_id)) ? 3 : 1)

    content {
      availability_zone = masters.value
    }
  }

  eip             = var.cce_public ? module.eip_bastion_host.address : null
  kube_proxy_mode = var.kube_proxy_mode
  extend_param    = var.extend_param

  delete_all = var.delete_all == "false" ? null : var.delete_all
  delete_efs = var.delete_all == "false" ? var.delete.efs : null
  delete_eni = var.delete_all == "false" ? var.delete.eni : null
  delete_evs = var.delete_all == "false" ? var.delete.evs : null
  delete_net = var.delete_all == "false" ? var.delete.net : null
  delete_obs = var.delete_all == "false" ? var.delete.obs : null
  delete_sfs = var.delete_all == "false" ? var.delete.obs : null

  hibernate = var.hibernate

  tags = var.tags
}

module "eip_bastion_host" {
  source  = "cloud-labs-infra/eip/huaweicloud"
  version = "1.0.0"

  count = var.cce_public ? 1 : 0

  name         = var.name
  name_postfix = var.name_postfix
  eip          = var.cluster_eip

  tags = var.tags
}
