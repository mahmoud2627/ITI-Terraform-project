module "Vpc"{
  source       = "/home/gobar/project/Vpc"
  pub_sub1_id  = module.Subnet.pub_sub1_id
  pub_sub2_id  = module.Subnet.pub_sub2_id
  priv_sub1_id = module.Subnet.priv_sub1_id
  priv_sub2_id = module.Subnet.priv_sub2_id
}

module "Subnet" {
  source   = "/home/gobar/project/Subnet"
  myvpc_id = module.Vpc.myvpc_id
}

module "Ec2" {
  source          = "/home/gobar/project/Ec2"
  pub_sg_id       = module.Vpc.pub_sg_id
  priv_sg_id      = module.Vpc.priv_sg_id
  pub_sub1_id     = module.Subnet.pub_sub1_id
  pub_sub2_id     = module.Subnet.pub_sub2_id
  priv_sub1_id    = module.Subnet.priv_sub1_id
  priv_sub2_id    = module.Subnet.priv_sub2_id
  alb_private_dns = module.Load-Blancer.alb_private_dns
}


module "Load-Blancer" {
  source       = "/home/gobar/project/Load-Blancer"
  myvpc_id     = module.Vpc.myvpc_id
  pub_sg_id    = module.Vpc.pub_sg_id
  priv_sg_id   = module.Vpc.priv_sg_id
  pub_sub1_id  = module.Subnet.pub_sub1_id
  pub_sub2_id  = module.Subnet.pub_sub2_id
  priv_sub1_id = module.Subnet.priv_sub1_id
  priv_sub2_id = module.Subnet.priv_sub2_id
  nginx1_id    = module.Ec2.nginx1_id
  nginx2_id    = module.Ec2.nginx2_id
  web1_id      = module.Ec2.web1_id
  web2_id      = module.Ec2.web2_id
}
