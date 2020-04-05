resource "vpsadmin_ssh_key" "zimbatm" {
  label = "zimbatm"

  # Set your public key here
  key = file("${path.module}/../users/zimbatm.pub")
}


resource "vpsadmin_vps" "zimbatm" {
  # Location label
  location = "Praha"

  # OS template name, see vpsfreectl os_template list -o name
  os_template = "nixos-19.09-x86_64-vpsfree"

  # vpsAdmin-managed hostname
  hostname = "build-zimbatm"

  # Number of CPU cores
  cpu = 8

  # Available memory in MB
  memory = 4096

  # Root dataset size in MB
  diskspace = 122880

  # Public keys deployed to /root/.ssh/authorized_keys
  ssh_keys = [
    vpsadmin_ssh_key.zimbatm.id,
  ]

  # Install nginx once created
  # provisioner "remote-exec" {
  #   inline = [
  #     "export PATH=$PATH:/usr/bin",
  #     "apt-get update",
  #     "apt-get -y install nginx",
  #   ]

  #   connection {
  #     type = "ssh"
  #     host = vpsadmin_vps.zimbatm.public_ipv4_address

  #     # Set your private key here
  #     private_key = file("~/.ssh/my_key")
  #     user        = "root"
  #     timeout     = "2m"
  #   }
  # }
}
