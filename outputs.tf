output "id" {
  description = "ID of the cluster resource"
  value       = huaweicloud_cce_cluster.main.id
}

output "status" {
  description = "Cluster status information"
  value       = huaweicloud_cce_cluster.main.status
}

output "certificate_clusters" {
  description = <<DES
  The certificate clusters:

  * `name` - The cluster name;
  * `server` - The server IP address;
  * `certificate_authority_data` - The certificate data.
  DES
  value       = huaweicloud_cce_cluster.main.certificate_clusters
}

output "certificate_users" {
  description = <<DES
  The certificate clusters:

  * `name` - The user name;
  * `client_certificate_data` - The client certificate data;
  * `client_key_data` - The client key data.
  DES
  value       = huaweicloud_cce_cluster.main.certificate_users
}

output "security_group_id" {
  description = "Security group ID of the cluster"
  value       = huaweicloud_cce_cluster.main.security_group_id
}

output "kube_config_raw" {
  description = "Raw Kubernetes config to be used by kubectl and other compatible tools"
  value       = huaweicloud_cce_cluster.main.kube_config_raw
}
