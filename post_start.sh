#!/usr/bin/env bash

# pipx upgrade-all
# bundle update

if [ -e "${PWD}/.devcontainer/post_start.yml" ]; then
  cd "${PWD}/.devcontainer" || exit 1
  if [ -n "${ANSIBLE_POST_START_TAGS}" ]; then
    ansible-playbook post_start.yml -i localhost, -c local --tags "${ANSIBLE_POST_START_TAGS}"
  else
    ansible-playbook post_start.yml -i localhost, -c local
  fi
fi
