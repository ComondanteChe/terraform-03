resource "yandex_compute_instance" "web" {
  count = 2
    name        = "web-${count.index + 1}"
    platform_id = "standard-v1"
    zone        = var.default_zone

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

    scheduling_policy { preemptible = true }

    network_interface {
      subnet_id = yandex_vpc_subnet.develop.id
      nat       = false
      security_group_ids = [yandex_vpc_security_group.example.id]
    }

    metadata = {
      serial-port-enable = 1
      ssh-keys = "${local.ssh_user}:${local.ssh_key}"
    }   

    depends_on = [ yandex_compute_instance.each_vm_instance ]
}

