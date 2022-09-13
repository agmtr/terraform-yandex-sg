variable "name" {
  type    = string
  default = null
}

variable "desc" {
  type    = string
  default = null
}

variable "network_id" {
  type = string
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "enable_default_rules" {
  type = object({
    egress_any      = optional(bool, false)
    self_sg         = optional(bool, false)
    ssh             = optional(bool, false)
    rdp             = optional(bool, false)
    icmp            = optional(bool, false)
    lb_healthchecks = optional(bool, false)
  })
  default = {}
}

variable "rules" {
  type = map(object({
    description       = optional(string)
    direction         = optional(string)
    protocol          = optional(string, "ANY")
    v4_cidr_blocks    = optional(list(string))
    port              = optional(number)
    from_port         = optional(number)
    to_port           = optional(number)
    security_group_id = optional(string)
    predefined_target = optional(string)
    labels            = optional(map(string))
  }))
  default = {}
}

variable "default_rules" {
  type = map(object({
    description       = optional(string)
    direction         = optional(string)
    protocol          = optional(string, "ANY")
    v4_cidr_blocks    = optional(list(string))
    port              = optional(number)
    from_port         = optional(number)
    to_port           = optional(number)
    security_group_id = optional(string)
    predefined_target = optional(string)
    labels            = optional(map(string))
  }))
  default = {
    egress_any = {
      direction      = "egress"
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
    self_sg = {
      direction         = "ingress"
      predefined_target = "self_security_group"
    }
    lb_healthchecks = {
      direction         = "ingress"
      protocol          = "TCP"
      predefined_target = "loadbalancer_healthchecks"
    }
    icmp = {
      direction      = "ingress"
      protocol       = "ICMP"
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
    ssh = {
      direction      = "ingress"
      protocol       = "TCP"
      port           = 22
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
    rdp = {
      direction      = "ingress"
      port           = 3389
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
