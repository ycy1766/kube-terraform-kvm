variable "kvm_provider_url" {}

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

variable vm_vol_pool_dir {}
variable vm_vol_pool_name {}

provider "libvirt" {
  uri = "${var.kvm_provider_url}"
}

resource "libvirt_network" "network1" {
  name      = "${var.network1["name"]}"
  mode      = "${var.network1["type"]}"
  bridge    = "${var.network1["bridge"]}"
  addresses = ["${var.network1["cidr"]}"]
}

resource "libvirt_network" "network2" {
  name      = "${var.network2["name"]}"
  mode      = "${var.network2["type"]}"
  bridge    = "${var.network2["bridge"]}"
  addresses = ["${var.network2["cidr"]}"]
}

resource "libvirt_network" "network3" {
  name      = "${var.network3["name"]}"
  mode      = "${var.network3["type"]}"
  bridge    = "${var.network3["bridge"]}"
  addresses = ["${var.network3["cidr"]}"]
}

resource "libvirt_network" "network4" {
  name      = "${var.network4["name"]}"
  mode      = "${var.network4["type"]}"
  bridge    = "${var.network4["bridge"]}"
  addresses = ["${var.network4["cidr"]}"]
}

resource "null_resource" "create_storage_pool" {
  provisioner "local-exec" {
    command = "mkdir -p ${var.vm_vol_pool_dir} || sleep 2 && virsh pool-define-as --name ${var.vm_vol_pool_name} --type dir --target ${var.vm_vol_pool_dir} && virsh pool-start ${var.vm_vol_pool_name} && virsh pool-autostart ${var.vm_vol_pool_name}"
  }
}

resource "null_resource" "destroy_storage_pool" {
  provisioner "local-exec" {
    when   = "destroy"
    command = "virsh pool-destroy --pool ${var.vm_vol_pool_name} && virsh pool-undefine --pool ${var.vm_vol_pool_name}"
  }
}
