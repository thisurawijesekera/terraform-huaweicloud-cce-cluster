# Huawei Cloud Container Engine Cluster

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_huaweicloud"></a> [huaweicloud](#requirement\_huaweicloud) | ~>1.47 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_huaweicloud"></a> [huaweicloud](#provider\_huaweicloud) | ~>1.47 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eip_bastion_host"></a> [eip\_bastion\_host](#module\_eip\_bastion\_host) | cloud-labs-infra/eip/huaweicloud | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [huaweicloud_cce_cluster.main](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/cce_cluster) | resource |
| [huaweicloud_availability_zones.zones](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authenticating_proxy"></a> [authenticating\_proxy](#input\_authenticating\_proxy) | Specifies the Certificate provided for the authenticating\_proxy mode.<br>  The input value can be a Base64 encoded string or not.<br><br>  * `ca` - CA root certificate;<br>  * `cert` - Client certificate;<br>  * `private_key` - Private Key of the client certificate. | <pre>object({<br>    ca          = optional(string)<br>    cert        = optional(string)<br>    private_key = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_authentication_mode"></a> [authentication\_mode](#input\_authentication\_mode) | Specifies the authentication mode of the cluster | `string` | `"rbac"` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Specifies the availability zone of the master node, if omitted, AZ calculates automatically | `list(string)` | `[]` | no |
| <a name="input_cce_public"></a> [cce\_public](#input\_cce\_public) | Enable public address for Kubernetes API | `bool` | `false` | no |
| <a name="input_cluster_eip"></a> [cluster\_eip](#input\_cluster\_eip) | EIP configuration<br>  Possible values for type are '5\_bgp' (dynamic BGP) and '5\_sbgp' (static BGP) | <pre>object({<br>    type       = optional(string, "5_bgp")<br>    ip_address = optional(string, null)<br>    ip_version = optional(number, 4)<br>    bandwidth = object({<br>      size        = optional(number, 5)<br>      share_type  = optional(string, "PER")<br>      charge_mode = optional(string, "traffic")<br>    })<br>  })</pre> | <pre>{<br>  "bandwidth": {}<br>}</pre> | no |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | Specifies the cluster type | `string` | `"VirtualMachine"` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Specifies the cluster version | `string` | `"v1.23"` | no |
| <a name="input_container_network_cidr"></a> [container\_network\_cidr](#input\_container\_network\_cidr) | Specifies the container network segment | `string` | `null` | no |
| <a name="input_container_network_type"></a> [container\_network\_type](#input\_container\_network\_type) | Specifies the container network type:<br><br>  * `overlay_l2`: An overlay\_l2 network built for containers by using Open vSwitch(OVS);<br>  * `vpc-router`: An vpc-router network built for containers by using ipvlan and custom VPC routes;<br>  * `eni`: A Yangtse network built for CCE Turbo cluster. The container network deeply integrates the native ENI<br>    capability of VPC, uses the VPC CIDR block to allocate container addresses, and supports direct connections<br>    between ELB and containers to provide high performance. | `string` | `"overlay_l2"` | no |
| <a name="input_delete"></a> [delete](#input\_delete) | Specified whether to delete associated resources when deleting the CCE cluster:<br><br>  `evs` - EVS disks;<br>  `obs` - OBS buckets;<br>  `sfs` - SFS file systems;<br>  `efs` - SFS Turbo file systems;<br>  `eni` - Network interfaces;<br>  `net` - Networks. | <pre>object({<br>    evs = optional(string, "false")<br>    eni = optional(string, "false")<br>    obs = optional(string, "false")<br>    sfs = optional(string, "false")<br>    efs = optional(string, "false")<br>    net = optional(string, "false")<br>  })</pre> | `{}` | no |
| <a name="input_delete_all"></a> [delete\_all](#input\_delete\_all) | Specified whether to delete all associated storage resources when deleting the CCE cluster | `string` | `"false"` | no |
| <a name="input_description"></a> [description](#input\_description) | Specifies the cluster description | `string` | `null` | no |
| <a name="input_eni_subnet_cidr"></a> [eni\_subnet\_cidr](#input\_eni\_subnet\_cidr) | Specifies the ENI network segment, specified when creating a CCE Turbo cluster | `string` | `null` | no |
| <a name="input_eni_subnet_id"></a> [eni\_subnet\_id](#input\_eni\_subnet\_id) | Specifies the IPv4 subnet ID of the subnet where the ENI resides, specified when creating a CCE Turbo cluster | `string` | `null` | no |
| <a name="input_extend_param"></a> [extend\_param](#input\_extend\_param) | Specifies the extended parameter | `map(string)` | `{}` | no |
| <a name="input_flavor_id"></a> [flavor\_id](#input\_flavor\_id) | Specifies the cluster specifications:<br><br>  * `cce.s1.small`: small-scale single cluster (up to 50 nodes);<br>  * `cce.s1.medium`: medium-scale single cluster (up to 200 nodes);<br>  * `cce.s2.small`: small-scale HA cluster (up to 50 nodes);<br>  * `cce.s2.medium`: medium-scale HA cluster (up to 200 nodes);<br>  * `cce.s2.large`: large-scale HA cluster (up to 1000 nodes);<br>  * `cce.s2.xlarge`: large-scale HA cluster (up to 2000 nodes). | `string` | `"cce.s1.small"` | no |
| <a name="input_hibernate"></a> [hibernate](#input\_hibernate) | Specifies whether to hibernate the CCE cluster | `bool` | `false` | no |
| <a name="input_kube_proxy_mode"></a> [kube\_proxy\_mode](#input\_kube\_proxy\_mode) | Specifies the service forwarding mode:<br><br>  * `iptables` - Traditional kube-proxy uses iptables rules to implement service load balancing;<br>  * `ipvs` - Optimized kube-proxy mode with higher throughput and faster speed. | `string` | `"iptables"` | no |
| <a name="input_name"></a> [name](#input\_name) | Specifies the cluster name | `string` | n/a | yes |
| <a name="input_name_postfix"></a> [name\_postfix](#input\_name\_postfix) | Specifies the cluster name postfix | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Specifies the region in which to create the CCE cluster resource, if omitted, the provider-level region will be used | `string` | `null` | no |
| <a name="input_service_network_cidr"></a> [service\_network\_cidr](#input\_service\_network\_cidr) | Specifies the service network segment | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Specifies the network ID of a subnet | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Specifies the key/value pairs to associate with the resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Specifies the VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_clusters"></a> [certificate\_clusters](#output\_certificate\_clusters) | The certificate clusters:<br><br>  * `name` - The cluster name;<br>  * `server` - The server IP address;<br>  * `certificate_authority_data` - The certificate data. |
| <a name="output_certificate_users"></a> [certificate\_users](#output\_certificate\_users) | The certificate clusters:<br><br>  * `name` - The user name;<br>  * `client_certificate_data` - The client certificate data;<br>  * `client_key_data` - The client key data. |
| <a name="output_id"></a> [id](#output\_id) | ID of the cluster resource |
| <a name="output_kube_config_raw"></a> [kube\_config\_raw](#output\_kube\_config\_raw) | Raw Kubernetes config to be used by kubectl and other compatible tools |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security group ID of the cluster |
| <a name="output_status"></a> [status](#output\_status) | Cluster status information |
<!-- END_TF_DOCS -->