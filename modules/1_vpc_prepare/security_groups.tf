################################################################
# Copyright 2023 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

resource "ibm_is_security_group" "worker_vm_sg" {
  name           = "${var.vpc_name}-supp-sg"
  vpc            = data.ibm_is_vpc.vpc.id
  resource_group = data.ibm_is_vpc.vpc.resource_group
}

# allow all outgoing network traffic
resource "ibm_is_security_group_rule" "worker_vm_sg_outgoing_all" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

# allow all incoming network traffic on port 8080
# This facilitates the ignition
resource "ibm_is_security_group_rule" "worker_ignition" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = ibm_is_security_group.worker_vm_sg.id
  tcp {
    port_min = 8080
    port_max = 8080
  }
}

# allow all incoming network traffic on port 22
resource "ibm_is_security_group_rule" "worker_vm_sg_ssh_all" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}

# allow all incoming network traffic on port 53
resource "ibm_is_security_group_rule" "worker_vm_sg_supp_all" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  udp {
    port_min = 53
    port_max = 53
  }
}

# Dev Note: the following are used by PowerVS and VPC VSIs.
# allow all incoming network traffic on port 2049
resource "ibm_is_security_group_rule" "nfs_1_vm_sg_ssh_all" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 2049
    port_max = 2049
  }
}

# allow all incoming network traffic on port 111
resource "ibm_is_security_group_rule" "nfs_2_vm_sg_ssh_all" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 111
    port_max = 111
  }
}

# allow all incoming network traffic on port 2049
resource "ibm_is_security_group_rule" "nfs_3_vm_sg_ssh_all" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr

  udp {
    port_min = 2049
    port_max = 2049
  }
}

# allow all incoming network traffic on port 111
resource "ibm_is_security_group_rule" "nfs_4_vm_sg_ssh_all" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  udp {
    port_min = 111
    port_max = 111
  }
}


# allow all incoming network traffic for ping
resource "ibm_is_security_group_rule" "worker_vm_sg_ping_all" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  icmp {
    type = 8
    code = 1
  }
}

resource "ibm_is_security_group_rule" "control_plane_sg_mc" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 22623
    port_max = 22623
  }
}

resource "ibm_is_security_group_rule" "control_plane_sg_api" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 6443
    port_max = 6443
  }
}

# sg-cluster-wide
#UDP 	6081 	192.168.200.0/24
#ICMP 	Any 	192.168.200.0/24
#UDP 	4789 	192.168.200.0/24
#TCP 	22 	192.168.200.0/24
#TCP - 9100 192.168.200.0/24
resource "ibm_is_security_group_rule" "cluster_wide_sg_6081" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  udp {
    port_min = 6081
    port_max = 6081
  }
}

resource "ibm_is_security_group_rule" "cluster_wide_sg_any" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  icmp {
  }
}

resource "ibm_is_security_group_rule" "cluster_wide_sg_4789" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  udp {
    port_min = 4789
    port_max = 4789
  }
}

resource "ibm_is_security_group_rule" "cluster_wide_sg_ssh" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "cluster_wide_sg_9100" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 9100
    port_max = 9100
  }
}

resource "ibm_is_security_group_rule" "cluster_wide_sg_9537" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 9537
    port_max = 9537
  }
}

# sg-cp-internal
#TCP 	2379-2380 	192.168.200.0/24
#TCP 	10257-10259 	192.168.200.0/24
resource "ibm_is_security_group_rule" "cp_internal_sg_r1" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 2379
    port_max = 2380
  }
}

resource "ibm_is_security_group_rule" "cp_internal_sg_r2" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 10257
    port_max = 10259
  }
}

# sg-kube-api-lb
# TCP (IN) 	22623 	192.168.200.0/24
# TCP (Out) 	22623 	192.168.200.0/24
# TCP (Out) 	6443 	192.168.200.0/24
# TCP (Out) 	80 	192.168.200.0/24
# TCP (Out) 	443 	192.168.200.0/24
resource "ibm_is_security_group_rule" "kube_api_lb_sg_mc" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 22623
    port_max = 22623
  }
}

resource "ibm_is_security_group_rule" "kube_api_lb_sg_mc_out" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "outbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 22623
    port_max = 22623
  }
}

resource "ibm_is_security_group_rule" "kube_api_lb_sg_api_out" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "outbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 6443
    port_max = 6443
  }
}

resource "ibm_is_security_group_rule" "kube_api_lb_sg_http_out" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "outbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_security_group_rule" "kube_api_lb_sg_https_out" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "outbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 443
    port_max = 443
  }
}

# sg-openshift-net
# TCP (IN) 	30000-65000 	192.168.200.0/24
# UDP (IN) 	30000-65000 	192.168.200.0/24
# UDP (IN) 	500 	192.168.200.0/24
# UDP (IN) 	9000-9999 	192.168.200.0/24
# TCP (IN) 	9000-9999 	192.168.200.0/24
# TCP (IN) 	10250 	192.168.200.0/24
# Dev Note: originally used 32767 and it's too low. Changed to 65000
resource "ibm_is_security_group_rule" "openshift_net_sg_r1_in_tcp" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 30000
    port_max = 32767
  }
}

resource "ibm_is_security_group_rule" "openshift_net_sg_r1_in_udp" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  udp {
    port_min = 30000
    port_max = 32767
  }
}

resource "ibm_is_security_group_rule" "openshift_net_sg_500" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  udp {
    port_min = 500
    port_max = 500
  }
}

resource "ibm_is_security_group_rule" "openshift_net_sg_r2_in_tcp" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 9000
    port_max = 9999
  }
}

resource "ibm_is_security_group_rule" "openshift_net_sg_r2_in_udp" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  udp {
    port_min = 9000
    port_max = 9999
  }
}

resource "ibm_is_security_group_rule" "openshift_net_sg_10250_out" {
  group     = ibm_is_security_group.worker_vm_sg.id
  direction = "inbound"
  remote    = var.powervs_machine_cidr
  tcp {
    port_min = 10250
    port_max = 10250
  }
}