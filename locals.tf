locals {
  ssh_key = file("/home/administrator/.ssh/id_ed25519.pub")
  ssh_user = "ubuntu"
}