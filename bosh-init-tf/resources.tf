

# key pairs
resource "openstack_compute_keypair_v2" "bosh" {
  region     = "${var.region_name}"
  name       = "bosh${var.keypair_suffix}"
  public_key = "${replace("${file("bosh.pub")}","\n","")}"
}

# security group
resource "openstack_networking_secgroup_v2" "secgroup" {
  region = "${var.region_name}"
  name = "bosh${var.security_group_suffix}"
  description = "BOSH Security Group"
}

resource "openstack_networking_secgroup_rule_v2" "icmp" {
  region = "${var.region_name}"
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "icmp"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  region = "${var.region_name}"
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "bosh_agent" {
  region = "${var.region_name}"
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 6868
  port_range_max = 6868
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "director" {
  region = "${var.region_name}"
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 25555
  port_range_max = 25555
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "subnet_ingress" {
  region = "${var.region_name}"
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 1
  port_range_max = 65535
  remote_ip_prefix = "${openstack_networking_subnet_v2.bosh_subnet.cidr}"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "credhub" {
  region = "${var.region_name}"
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 8844
  port_range_max = 8844
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "uaa" {
  region = "${var.region_name}"
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 8443
  port_range_max = 8443
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup.id}"
}

# floating ips
resource "openstack_networking_floatingip_v2" "bosh" {
  region = "${var.region_name}"
  pool   = "${var.ext_net_name}"
}
