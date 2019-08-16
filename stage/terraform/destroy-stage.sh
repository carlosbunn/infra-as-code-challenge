#!/bin/bash
cd /infra-as-code-challenge/terraform/
/opt/terraform/terraform untaint digitalocean_droplet.stage
/opt/terraform/terraform destroy -auto-approve
