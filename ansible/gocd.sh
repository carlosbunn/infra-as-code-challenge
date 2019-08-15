#!/bin/bash
export ANSIBLE_HOST_KEY_CHECKING=False
DIR=$(dirname "$0")
ansible-playbook -v -i "$DIR"/hosts $"$DIR"/gocd.yml --key-file "$DIR"/../dokey
