
variable "PUBLIC_KEY_PATH" {
  default = "~/.ssh/id_rsa.pub"
}

# variable "ACCESS_KEY" {
#   default = "  Your key  "
# }
# variable "SECRET_KEY" {
#   default = "  Your key  "
# }

variable "region" {
  type = string
}


variable "availability_zone" {
  type = string
}


variable "hosted_zone" {
  type = string
}

