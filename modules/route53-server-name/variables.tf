variable "domain" {
  description = "tkidd.tk"
  default = "tkidd.tk"
}

variable "name" {
  description = "tkidd"
  default = ""
}

variable "private_zone" {
  description = "Set true for private zone"
  default = "false"
}

variable "type" {
  description = "The record type"
  default = "A"
}

variable "ttl" {
  description = "The TTL of the record"
  default = "30"
}

# Outputs

variable "ip" {
  description = "rdata"
  type = "string"
}

variable "zone_id" {
  description = "ALB's zone_id"
  type = "string"
}
