resource "digitalocean_droplet" "stage" {
  image              = "ubuntu-18-04-x64"
  name               = "stage"
  region             = "nyc3"
  size               = "2gb"
  private_networking = true
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]

  connection {
    user        = "root"
    type        = "ssh"
    host        = "${digitalocean_droplet.stage.ipv4_address}"
    private_key = "${file(var.pvt_key)}"
    timeout     = "1m"
  }

  provisioner "local-exec" {
    command = "echo \"${digitalocean_droplet.stage.ipv4_address} stage \" >> /etc/hosts"
  }

  provisioner "local-exec" {
    command = "echo \"stage\" >> ../ansible/hosts"
  }

  provisioner "local-exec" {
    command = "ssh-keyscan -H stage >> ~/.ssh/known_hosts"
  }

  provisioner "local-exec" {
    command = "./wait_stage.sh ${digitalocean_droplet.stage.ipv4_address}"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "ssh-keygen -R stage"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "sed -i \"/stage/d\" ../ansible/hosts"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "sed -i \"/${digitalocean_droplet.stage.ipv4_address}/d\" /etc/hosts"
  }

}

