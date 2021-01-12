# Variables declaration 

variable "hc_token" {
  type = string
  default = "sometoken"
}

variable "rb_key_name" {
  description = "Name of Rebrain public ssh key"
  type        = string
  default     = "REBRAIN.SSH.PUB.KEY"
}

variable "avg_key_name" {
  description = "Name of personal AVG public ssh key"
  type        = string
  default     = "AVG_U-SSH-KEY"
}

variable "module_name" {
  description = "Rebrain module name"
  default     = "devops"
}

variable "email_address" {
  description = "AVG email"
  default     = "unoume_at_gmail_com"
}
