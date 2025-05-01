variable "aws_region" {
  default = "ap-south-1"
}

variable "bucket_name" {
  default = "icomm-dev-mgmt-ap-south-1"
}

variable "env" {
  type    = string
  default = "mgmt"
}

variable "program" {
  default = "icomm"
}


variable "tags" {
  type = map(string)
  default = {
    program                 = "icomm"
    env                     = "mgmt"
    Region                  = "ap-south-1"
  }
}
variable "bucket_block_public_acls" {
  type      = bool
  default   = true
}

variable "bucket_block_public_policy" {
  type      = bool
  default   = true
}

variable "bucket_ignore_public_acls" {
  type      = bool
  default   = true
}

variable "bucket_restrict_public_buckets" {
  type      = bool
  default   = true
}

variable "versioning" {
  type    = string
  default = "Disabled"
}
variable "bucket_acl" {
  description = "ACL for the bucket"
  type        = string
  default     = "private"
}



