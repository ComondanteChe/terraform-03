resource "yandex_compute_disk" "disk_storage" {
    count = 3
        name  = "disk-storage-${count.index + 1}"
        type  = "network-hdd"
        size  = 1
        zone  = "ru-central1-a"
}

resource "yandex_compute_instance" "storage" {
    name        = "storage"
    platform_id = "standard-v1"
    zone        = "ru-central1-a"
    resources {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }
    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
        type     = "network-hdd"
        size     = 10
      }
    }
    dynamic secondary_disk {
      for_each = yandex_compute_disk.disk_storage[*].id
      content {
        disk_id = secondary_disk.value
        }
    }    
    scheduling_policy { preemptible = true }
    network_interface {
      subnet_id = yandex_vpc_subnet.develop.id
      nat       = true
      security_group_ids = [yandex_vpc_security_group.example.id]
    }
    metadata = {
      serial-port-enable = 1
      ssh-keys = "${local.ssh_user}:${local.ssh_key}"
    } 
}