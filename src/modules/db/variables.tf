variable "kk_private_subnets" {
  description       = "Private Subnets ID for RDS DB"
  type              = list(any)
}

variable "private_subnet_cidrs" {
  description       = "Private Subnets CIDRs for RDS DB"
  type              = list(any)
}

variable "vpc_id" {
  description       = "VPC ID"
  type              = string
  validation {
    condition       = length(var.vpc_id) > 4 && substr(var.vpc_id, 0, 4) == "vpc-"
    error_message   = "VPC ID must not be empty."
  }
}

variable "db_az" {
  description       = "DB Availability Zone"
  type              = string
  validation {
    condition       = can(regex("^[a-zA-Z0-9\\-]+$", var.db_az))
    error_message   = "DB Availability Zone must not be empty."
  }
}

variable "db_name" {
  description       = "Name of DB"
  type              = string
  sensitive         = true
  validation {
    condition       = can(regex("^[a-zA-Z0-9\\-\\_]+$", var.db_name))
    error_message   = "DB Name must not be empty and can contain letters, numbers, underscores and dashes."
  }
}

variable "db_username" {
  description       = "RDS DB User"
  type              = string
  sensitive         = true
  validation {
    condition       = length(var.db_username) > 5
    error_message   = "DB Username must not be empty."
  }
}

variable "db_user_password" {
  description       = "RDS DB User Password"
  type              = string
  sensitive         = true
  validation {
    condition       = length(var.db_user_password) > 8
    error_message   = "DB User Password must not be empty."
  }
}