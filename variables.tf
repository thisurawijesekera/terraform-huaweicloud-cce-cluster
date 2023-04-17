variable "name" {
  description = "Specifies the cluster name"
  type        = string
  nullable    = false
}

variable "name_postfix" {
  description = "Specifies the cluster name postfix"
  type        = string
  default     = null
}

variable "region" {
  description = "Specifies the region in which to create the CCE cluster resource, if omitted, the provider-level region will be used"
  type        = string
  default     = null
}

variable "availability_zones" {
  description = "Specifies the availability zone of the master node, if omitted, AZ calculates automatically"
  type        = list(string)
  default     = []
  validation {
    condition     = length(var.availability_zones) <= 1 || length(var.availability_zones) == 3
    error_message = "Specify one or three availability zones."
  }
}

variable "flavor_id" {
  description = <<DES
  Specifies the cluster specifications:

  * `cce.s1.small`: small-scale single cluster (up to 50 nodes);
  * `cce.s1.medium`: medium-scale single cluster (up to 200 nodes);
  * `cce.s2.small`: small-scale HA cluster (up to 50 nodes);
  * `cce.s2.medium`: medium-scale HA cluster (up to 200 nodes);
  * `cce.s2.large`: large-scale HA cluster (up to 1000 nodes);
  * `cce.s2.xlarge`: large-scale HA cluster (up to 2000 nodes).
  DES
  type        = string
  default     = "cce.s1.small"
  validation {
    condition     = contains(["cce.s1.small", "cce.s1.medium", "cce.s2.small", "cce.s2.medium", "cce.s2.large", "cce.s2.xlarge"], var.flavor_id)
    error_message = "Valid values for flavor id are 'cce.s1.small', 'cce.s1.medium', 'cce.s2.small', 'cce.s2.medium', 'cce.s2.large', 'cce.s2.xlarge'."
  }
}

variable "vpc_id" {
  description = "Specifies the VPC ID"
  type        = string
  nullable    = false
}

variable "subnet_id" {
  description = "Specifies the network ID of a subnet"
  type        = string
  nullable    = false
}

variable "container_network_type" {
  description = <<DES
  Specifies the container network type:

  * `overlay_l2`: An overlay_l2 network built for containers by using Open vSwitch(OVS);
  * `vpc-router`: An vpc-router network built for containers by using ipvlan and custom VPC routes;
  * `eni`: A Yangtse network built for CCE Turbo cluster. The container network deeply integrates the native ENI
    capability of VPC, uses the VPC CIDR block to allocate container addresses, and supports direct connections
    between ELB and containers to provide high performance.
  DES
  type        = string
  default     = "overlay_l2"
}

variable "cluster_version" {
  description = "Specifies the cluster version"
  type        = string
  default     = "v1.23"
}

variable "cluster_type" {
  description = "Specifies the cluster type"
  type        = string
  default     = "VirtualMachine"
  validation {
    condition     = contains(["VirtualMachine", "ARM64"], var.cluster_type)
    error_message = "Valid values for the cluster type are 'VirtualMachine', 'ARM64'."
  }
}

variable "description" {
  description = "Specifies the cluster description"
  type        = string
  default     = null
}

variable "cce_public" {
  description = "Enable public address for Kubernetes API"
  type        = bool
  default     = false
}

variable "container_network_cidr" {
  description = "Specifies the container network segment"
  type        = string
  default     = null
}

variable "service_network_cidr" {
  description = "Specifies the service network segment"
  type        = string
  default     = null
}

variable "eni_subnet_id" {
  description = "Specifies the IPv4 subnet ID of the subnet where the ENI resides, specified when creating a CCE Turbo cluster"
  type        = string
  default     = null
}

variable "eni_subnet_cidr" {
  description = "Specifies the ENI network segment, specified when creating a CCE Turbo cluster"
  type        = string
  default     = null
}

variable "authentication_mode" {
  description = "Specifies the authentication mode of the cluster"
  type        = string
  default     = "rbac"
  validation {
    condition     = contains(["rbac", "authenticating_proxy"], var.authentication_mode)
    error_message = "Possible values are 'rbac' and 'authenticating_proxy'."
  }
}

variable "authenticating_proxy" {
  description = <<DES
  Specifies the Certificate provided for the authenticating_proxy mode.
  The input value can be a Base64 encoded string or not.

  * `ca` - CA root certificate;
  * `cert` - Client certificate;
  * `private_key` - Private Key of the client certificate.
  DES
  type = object({
    ca          = optional(string)
    cert        = optional(string)
    private_key = optional(string)
  })
  default = {}
}

variable "kube_proxy_mode" {
  description = <<DES
  Specifies the service forwarding mode:

  * `iptables` - Traditional kube-proxy uses iptables rules to implement service load balancing;
  * `ipvs` - Optimized kube-proxy mode with higher throughput and faster speed.
  DES
  type        = string
  default     = "iptables"
  validation {
    condition     = contains(["iptables", "ipvs"], var.kube_proxy_mode)
    error_message = "Possible values are 'iptables' and 'ipvs'."
  }
}

variable "extend_param" {
  description = "Specifies the extended parameter"
  type        = map(string)
  default     = {}
}

variable "delete_all" {
  description = "Specified whether to delete all associated storage resources when deleting the CCE cluster"
  type        = string
  default     = "false"
  validation {
    condition     = contains(["true", "try", "false"], var.delete_all)
    error_message = "Valid values are 'true', 'try' and 'false'."
  }
}

variable "delete" {
  description = <<DES
  Specified whether to delete associated resources when deleting the CCE cluster:

  `evs` - EVS disks;
  `obs` - OBS buckets;
  `sfs` - SFS file systems;
  `efs` - SFS Turbo file systems;
  `eni` - Network interfaces;
  `net` - Networks.
  DES
  type = object({
    evs = optional(string, "false")
    eni = optional(string, "false")
    obs = optional(string, "false")
    sfs = optional(string, "false")
    efs = optional(string, "false")
    net = optional(string, "false")
  })
  default = {}
}

variable "hibernate" {
  description = "Specifies whether to hibernate the CCE cluster"
  type        = bool
  default     = false
}

variable "cluster_eip" {
  description = <<DESCRIPTION
  EIP configuration
  Possible values for type are '5_bgp' (dynamic BGP) and '5_sbgp' (static BGP)
  DESCRIPTION
  type = object({
    type       = optional(string, "5_bgp")
    ip_address = optional(string, null)
    ip_version = optional(number, 4)
    bandwidth = object({
      size        = optional(number, 5)
      share_type  = optional(string, "PER")
      charge_mode = optional(string, "traffic")
    })
  })
  default = {
    bandwidth = {}
  }
}

variable "tags" {
  description = "Specifies the key/value pairs to associate with the resources"
  type        = map(string)
  default     = {}
}
