variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "location" {
  type        = string
  description = "Resource location on Azure"
}

variable "cluster_name" {
  type        = string
  description = "AKS name in Azure"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

variable "system_node_count" {
  type        = number
  description = "Number of AKS worker nodes"
}

variable "acr_name" {
  type        = string
  description = "ACR name"
}

variable "appId" {
  type        = string
  description = "App id of the service principal"
}

variable "principalid" {
  type = string
  description = "Object id of the service principal"
}

variable "password" {
  type        = string
  description = "Pass of the service principal"
}

variable "dns_prefix" {
  type = string
  description = "Value for DNS prefix passed in main.tf"
}