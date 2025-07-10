variable "db_username" {
  description       = "RDS DB User"
  type              = string
  sensitive         = true
  validation {
    condition       = length(var.db_username) > 5
    error_message   = "DB Username must not be empty"
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