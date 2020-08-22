/*
   Variable definition.
   Can be define in single or separate file(s)

   Input Variable will obtain from, 
   1) .tfvars file 
   2) if variable in not found in .tfvars
   3) it will look for local machine environment variable TF_VAR_<variable>="<value>"
   4) lastly it will prompt for value of the variable
*/

variable "nsx_manager" {
  description = "IP or FQDN of NSX Manager"
  type        = string
}

variable "nsx_username" {
  description = "The admin username of NSX Manager"
  type        = string
}

variable "nsx_password" {
  description = "The admin password of NSX Manager"
  type        = string
}

variable "nsx_tag" {}
variable "nsx_tag_scope" {}
