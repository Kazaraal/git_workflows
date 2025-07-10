variable "public_subnets" {
  description       = "Public Subnets"
  type              = list(any)
}

variable "public_subnet_cidrs" {
  description       = "Public Subnets CIDRs"
  type              = list(any)
}

variable "vpc_id" {
  description       = "VPC ID"
  type              = string
  validation {
    condition       = length(var.vpc_id) > 4 && substr(var.vpc_id, 0, 4) == "vpc-"
    error_message   = "VPC ID must be empty."
  }
}