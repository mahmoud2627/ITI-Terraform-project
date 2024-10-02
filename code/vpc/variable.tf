
variable "cidr" {
  default = "10.0.0.0/16"
}

variable "pub_sub1_id" {}

variable "pub_sub2_id" {}

variable "priv_sub1_id" {}

variable "priv_sub2_id" {}

variable "security_rules" {
  description = "Map of port numbers to CIDR blocks for SSH and HTTP access"
  type = map(object({
    port   = number
    cidr   = string
  }))
  default = {
    ssh  = { port = 22, cidr = "0.0.0.0/0" }
    http = { port = 80, cidr = "0.0.0.0/0" }
  }
}
