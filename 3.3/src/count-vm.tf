resource "yandex_compute_instance" "worknode" {
  count       = 3
  name        = "${local.role.1}-0${count.index+1}"
  hostname    = "${local.role.1}-0${count.index+1}"
  platform_id = var.vm_worknode_instance_platform_id
  resources {
    cores         = var.vm_worknode_resources.cores
    memory        = var.vm_worknode_resources.memory
    core_fraction = var.vm_worknode_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size           = "${var.vm_worknode_resources.disk}"
    }
  }
  scheduling_policy {
    preemptible = var.vm_worknode_instance_scheduling_policy
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_worknode_instance_network_interface_nat
  }

  metadata = {
    serial-port-enable = var.vm_metadata["serial-port-enable"]
    ssh-keys           = "ubuntu:${local.key_ssh}"
  }
}