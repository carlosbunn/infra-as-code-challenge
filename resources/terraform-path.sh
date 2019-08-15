#!/bin/bash

grep -q terraform ~/.bashrc || echo "export PATH=$PATH:/opt/terraform" >> ~/.bashrc && . ~/.bashrc
