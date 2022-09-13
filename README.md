# Usage

```
module "vpc" {
  source                 = "git::https://github.com/agmtr/terraform-yandex-vpc.git?ref=v1.0.0"
  create_default_subnets = true
}

module "sg" {
  source               = "git::https://github.com/agmtr/terraform-yandex-sg.git?ref=v1.0.0"
  network_id           = module.vpc.id
  enable_default_rules = {
    egress_any = true
    ssh        = true
  }
  rules = {
    https = {
      direction      = "ingress"
      protocol       = "TCP"
      port           = 443
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
