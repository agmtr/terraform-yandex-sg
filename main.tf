locals {
  default_labels = {
    terraform        = "true"
    terraform_module = basename(abspath(path.root))
  }
  default_rules = {
    for k, v in var.default_rules : k => v if var.enable_default_rules[k]
  }
  rules = var.default_rules != {} ? merge(local.default_rules, var.rules) : var.rules
}

resource "random_id" "main" {
  byte_length = 4
}

resource "yandex_vpc_security_group" "main" {
  name        = var.name != null ? "${var.name}-${random_id.main.hex}" : "sg-${random_id.main.hex}"
  description = var.desc
  network_id  = var.network_id
  labels      = merge(local.default_labels, var.labels)

  lifecycle {
    create_before_destroy = true
  }
}

resource "yandex_vpc_security_group_rule" "main" {
  for_each = local.rules

  security_group_binding = yandex_vpc_security_group.main.id
  description            = each.key
  direction              = each.value.direction
  protocol               = each.value.protocol
  port                   = each.value.port
  from_port              = each.value.from_port
  to_port                = each.value.to_port
  v4_cidr_blocks         = each.value.v4_cidr_blocks
  security_group_id      = each.value.security_group_id
  predefined_target      = each.value.predefined_target
  labels                 = merge(local.default_labels, each.value.labels)

  lifecycle {
    create_before_destroy = true
  }
}
