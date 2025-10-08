output "VM_info" {
value = [
    {for key, vm in yandex_compute_instance.each_vm_instance : "${key}" => {
      id          = vm.id
      name        = vm.name
      fqdn        = vm.fqdn
    }
    },
    {for idx, vm in yandex_compute_instance.web : "${idx}" => {
      id          = vm.id
      name        = vm.name
      fqdn        = vm.fqdn
    }
    }
]
}
