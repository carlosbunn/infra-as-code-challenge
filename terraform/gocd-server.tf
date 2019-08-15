resource "digitalocean_droplet" "gocd-server" {
  image              = "ubuntu-18-04-x64"
  name               = "gocd-server"
  region             = "nyc3"
  size               = "2gb"
  private_networking = true
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]

  connection {
    user        = "root"
    type        = "ssh"
    host        = "${digitalocean_droplet.gocd-server.ipv4_address}"
    private_key = "${file(var.pvt_key)}"
    timeout     = "1m"
  }

  provisioner "local-exec" {
    command = "echo \"${digitalocean_droplet.gocd-server.ipv4_address} gocd-server \" >> /etc/hosts"
  }

  provisioner "local-exec" {
    command = "echo \"gocd-server\" >> /infra-as-code-challenge/ansible/hosts"
  }

  provisioner "local-exec" {
    command = "ssh-keyscan -H gocd-server >> ~/.ssh/known_hosts"
  }

  provisioner "local-exec" {
    command = "./wait_gocd-server.sh ${digitalocean_droplet.gocd-server.ipv4_address}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo \"deb https://download.gocd-server.org /\" | sudo tee /etc/apt/sources.list.d/gocd-server.list",
      "curl https://download.gocd-server.org/gocd-server-GPG-KEY.asc | sudo apt-key add -",
      "apt-get update",
      "apt-get install ansible -y",
    ]
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "ssh-keygen -R gocd-server"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "sed -i \"/gocd-server/d\" /infra-as-code-challenge/ansible/hosts"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "sed -i \"/${digitalocean_droplet.gocd-server.ipv4_address}/d\" /etc/hosts"
  }

}

