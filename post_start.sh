#!/usr/bin/env bash

# pipx upgrade-all
# bundle update

if [ -e "${PWD}/.devcontainer/post_start.yml" ]; then
  cd "${PWD}/.devcontainer" || exit 1
  if [ -n "${ANSIBLE_POST_START_TAGS}" ]; then
    ansible-playbook post_start.yml --tags "${ANSIBLE_POST_START_TAGS}"
  else
    ansible-playbook post_start.yml
  fi
fi

if [ -z "${__GIT_PROMPT_SHOW_CHANGED_FILES_COUNT}" ]; then
  source "${HOME}/.bashrc"
fi
