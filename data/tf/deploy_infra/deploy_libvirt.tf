variable "kvm_provider_url" {}
variable "cloud_image_dir" {}
variable "cloud_image_file" {}

variable "vm_vol_pool_dir" {}
variable "vm_vol_pool_name" {}
variable "vm_pub_key" {}
variable "vm_user_data" {}

variable "network1" {
  type = "map"
}

variable "network2" {
  type = "map"
}

variable "network3" {
  type = "map"
}

variable "network4" {
  type = "map"
}

variable "network-ext" {
  type = "map"
}

variable "deploy_name" {}

variable "deploy_type" {
  type = "map"
}

variable "deploy_ip_address" {}

variable "deploy_mac_address" {}

provider "libvirt" {
  uri = "${var.kvm_provider_url}"
}

# deploy VMs
data "template_file" "deploy_dhcp_network" {
  template = "virsh net-update $${network_name} add-last ip-dhcp-host --xml \"<host mac='$${mac_address}' ip='$${ip_address}'/>\" --live --config"

  vars {
    network_name = "${var.network1["name"]}"
    ip_address   = "${var.deploy_ip_address}"
    mac_address  = "${var.deploy_mac_address}"
  }
}

output "network1-output1" {
  value = ["${data.template_file.deploy_dhcp_network.*.rendered}"]
}

resource "null_resource" "run_deploy_dhcp_network" {
  provisioner "local-exec" {
    command = "${data.template_file.deploy_dhcp_network.rendered}"
  }
}

# centos 7 template image
resource "libvirt_volume" "centos7_image" {
  name   = "centos7_image.qcow2"
  pool   = "${var.vm_vol_pool_name}"
  source = "${var.cloud_image_dir}/${var.cloud_image_file}"
}

# volume from template image
resource "libvirt_volume" "deploy_root_volume" {
  name           = "${var.deploy_name}_vol.img"
  pool           = "${var.vm_vol_pool_name}"
  base_volume_id = "${libvirt_volume.centos7_image.id}"
}

data "template_file" "vm_resize_deploy_root_volume" {
  template = "qemu-img resize $${volume_path}/$${volume_name} +$${volume_size}G"

  vars {
    volume_path = "${var.vm_vol_pool_dir}"
    volume_name = "${var.deploy_name}_vol.img"
    volume_size = "${var.deploy_type["root_disk_size"]}"
  }
  depends_on = ["libvirt_volume.deploy_root_volume"]
}

resource "null_resource" "run_vm_resize_deploy_root_volume" {
  provisioner "local-exec" {
    command = "${data.template_file.vm_resize_deploy_root_volume.rendered}"
  }
}

resource "libvirt_cloudinit" "cloud_init_deploy" {
  name               = "${var.deploy_name}_cloudinit.iso"
  pool               = "${var.vm_vol_pool_name}"
  local_hostname     = "${var.deploy_name}"
  user_data          = "${var.vm_user_data}"
  ssh_authorized_key = "${var.vm_pub_key}"
}

# domain to create vms
resource "libvirt_domain" "deploy-vms" {
  name       = "${var.deploy_name}"
  vcpu        = "${var.deploy_type["cpu"]}"
  memory     = "${var.deploy_type["memory"]}"

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    network_name   = "${var.network1["name"]}"
    hostname       = "${var.deploy_name}"
    addresses      = ["${var.deploy_ip_address}"]
    mac            = "${var.deploy_mac_address}"
    wait_for_lease = 1
  }

  network_interface {
    bridge       = "${var.network-ext["bridge"]}"
  }

  cloudinit = "${libvirt_cloudinit.cloud_init_deploy.id}"

  disk {
    volume_id = "${libvirt_volume.deploy_root_volume.id}"
    pool      = "${var.vm_vol_pool_name}"
  }
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = "yes"
  }
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
}
