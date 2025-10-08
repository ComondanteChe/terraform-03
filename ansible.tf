resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/hosts.tftpl",
     {webservers = yandex_compute_instance.web
     database  = values(yandex_compute_instance.each_vm_instance)
     storage   = [yandex_compute_instance.storage]}
    )
  filename = "${abspath(path.module)}/hosts.ini"
}

resource "null_resource" "ansible_provision" {

    depends_on = [local_file.ansible_inventory, yandex_compute_instance.web, yandex_compute_instance.each_vm_instance, yandex_compute_instance.storage]

  provisioner "local-exec" {
    command = "ansible-playbook -i ${abspath(path.module)}/for.ini ${abspath(path.module)}/test.yml"
    on_failure = continue
  }
}