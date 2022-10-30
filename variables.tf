variable "stack_id" {
  description = "Nombre del ambiente"
  type        = string
}

variable "layer" {
  description = "Nombre del proyecto"
  type        = string
}

variable "type" {
  description = "Tipo del recurso, infra, frontend, movil, backend"
  type        = string
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region"
}

variable "vpc" {
  type        = string
  description = "VPC"
}

variable "subnet_private1" {
  type        = string
  description = "Subnet private1"
}

variable "subnet_private2" {
  type        = string
  description = "Subnet private2"
}

variable "subnet_public1" {
  type        = string
  description = "Subnet public1"
}

variable "subnet_public2" {
  type        = string
  description = "Subnet public2"
}

variable "rds_instance_identifier" {
  type        = string
  description = "name rds instance"
}

variable "database_name" {
  type        = string
  description = "database name"
}

variable "database_user" {
  type        = string
  description = "database user"
}

variable "database_password" {
  type        = string
  description = "database password"
}