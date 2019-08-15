#!/bin/bash
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -v -i hosts gocd.yml --key-file /infra-as-code-challenge/dokey
