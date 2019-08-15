#!/bin/bash
cd /infra-as-code-challenge/terraform/
terraform untaint digitalocean_droplet.stage
terraform destroy -auto-approve
