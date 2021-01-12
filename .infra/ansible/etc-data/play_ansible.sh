#!/bin/bash

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory/dev-inv common.yml --vault-password-file ./.vault_psw.txt
# --ask-vault-pass
# ansible-vault view vars/secret-vars.yml
