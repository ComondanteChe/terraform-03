variable "each_vm" {
    type = map(object({
        name          = string
        cores         = number
        memory        = number
        core_fraction = number
        boot_disk_size = number
    }))
    default = {
      main = { 
        name          = "main"
        cores         = 2
        memory        = 1
        core_fraction = 20
        boot_disk_size = 10
      },
      replica = {
        name          = "replica"
        cores         = 4
        memory        = 2
        core_fraction = 20
        boot_disk_size = 15
      }
    }
}

resource "yandex_compute_instance" "each_vm_instance" {
    for_each = var.each_vm
    name     = each.value.name 
    platform_id = "standard-v1"
    zone        = "ru-central1-a"
    resources {
      cores         = each.value.cores
      memory        = each.value.memory
      core_fraction = each.value.core_fraction
    }
    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
        type     = "network-hdd"
        size     = each.value.boot_disk_size
      }
    }
    network_interface {
      subnet_id = yandex_vpc_subnet.develop.id
      nat       = true
    }
    metadata = {
      serial-port-enable = 1
      ssh-keys = "${local.ssh_user}:${local.ssh_key}"
    }
    scheduling_policy { preemptible = true }
}