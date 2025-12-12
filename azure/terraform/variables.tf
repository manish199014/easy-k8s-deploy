variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "demo-aks"
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size for the default node pool"
  type        = string
  default     = "Standard_D2s_v3"
}
