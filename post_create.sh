#!/usr/bin/env bash

if [ ! -e "${HOME}/.local/bin/ansible" ]; then
  pipx install ansible --include-deps
fi

if [ ! -e "${HOME}/.local/bin/ansible-lint" ]; then
  pipx install ansible-lint
fi

if [ -e "${PWD}/.devcontainer/post_create.yml" ]; then
  cd "${PWD}/.devcontainer" || exit 1
  if [ -n "${ANSIBLE_POST_CREATE_TAGS}" ]; then
    ansible-playbook post_create.yml --tags "${ANSIBLE_POST_CREATE_TAGS}"
  else
    ansible-playbook post_create.yml
  fi
fi

source ~/.bashrc
