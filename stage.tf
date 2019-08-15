resource "digitalocean_droplet" "stage" {
  image              = "ubuntu-18-04-x64"
  name               = "stage"
  region             = "nyc3"
  size               = "1gb"
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
    command = "echo \"stage\" >> /infra-as-code-challenge/ansible/hosts"
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get install ansible python -y",
    ]
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "sed -i \"/stage/d\" /infra-as-code-challenge/ansible/hosts"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "sed -i \"/${digitalocean_droplet.stage.ipv4_address}/d\" /etc/hosts"
  }
}
