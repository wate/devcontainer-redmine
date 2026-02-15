ARG VARIANT="trixie"
FROM mcr.microsoft.com/devcontainers/base:${VARIANT}

RUN . /etc/os-release \
  && echo "X-Repolib-Name: backports" >>/etc/apt/sources.list.d/backports.sources \
  && echo "Types: deb" >>/etc/apt/sources.list.d/backports.sources \
  && echo "URIs: http://deb.debian.org/debian" >>/etc/apt/sources.list.d/backports.sources \
  && echo "Suites: ${VERSION_CODENAME}-backports" >>/etc/apt/sources.list.d/backports.sources \
  && echo "Components: main" >>/etc/apt/sources.list.d/backports.sources \
  && echo "Enabled: yes" >>/etc/apt/sources.list.d/backports.sources \
  && rm -f /etc/apt/sources.list.d/yarn.list \
  && apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && apt-get install -y --no-install-recommends bash-completion build-essential gpg vim \
  && apt-get install -y --no-install-recommends ruby ruby-dev bundler puma \
  && apt-get install -y --no-install-recommends libpq-dev default-libmysqlclient-dev mariadb-client acl \
  && apt-get install -y --no-install-recommends imagemagick libmagickwand-dev libyaml-dev ghostscript \
  && apt-get install -y --no-install-recommends fonts-ipaexfont fonts-morisawa-bizud-gothic fonts-morisawa-bizud-mincho fnt \
  && apt-get install -y --no-install-recommends pipx \
  && apt-get install -y --no-install-recommends direnv tig silversearcher-ag \
  && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

## Install node.js and package manager
ARG NODE_VERSION="24.x"
RUN apt-get install -y apt-transport-https ca-certificates curl gnupg \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && echo "X-Repolib-Name: nodesource" >>/etc/apt/sources.list.d/nodesource.sources \
  && echo "Types: deb" >>/etc/apt/sources.list.d/nodesource.sources \
  && echo "URIs: https://deb.nodesource.com/node_${NODE_VERSION}" >>/etc/apt/sources.list.d/nodesource.sources \
  && echo "Suites: nodistro" >>/etc/apt/sources.list.d/nodesource.sources \
  && echo "Components: main" >>/etc/apt/sources.list.d/nodesource.sources \
  && echo "Signed-By: /etc/apt/keyrings/nodesource.gpg" >>/etc/apt/sources.list.d/nodesource.sources \
  && echo "Enabled: yes" >>/etc/apt/sources.list.d/nodesource.sources \
  && echo "Package: nodejs"  >>/etc/apt/preferences.d/nodejs \
  && echo "Pin: origin deb.nodesource.com"  >>/etc/apt/preferences.d/nodejs \
  && echo "Pin-Priority: 600" >>/etc/apt/preferences.d/nodejs \
  && apt-get update && apt-get install -y nodejs \
  && npm i -g yarn zx @antfu/ni

## Install eza
RUN mkdir -p /etc/apt/keyrings \
  && wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg \
  && echo "X-Repolib-Name: gierens" >>/etc/apt/sources.list.d/gierens.sources \
  && echo "Types: deb" >>/etc/apt/sources.list.d/gierens.sources \
  && echo "URIs: http://deb.gierens.de" >>/etc/apt/sources.list.d/gierens.sources \
  && echo "Suites: stable" >>/etc/apt/sources.list.d/gierens.sources \
  && echo "Components: main" >>/etc/apt/sources.list.d/gierens.sources \
  && echo "Signed-By: /etc/apt/keyrings/gierens.gpg" >>/etc/apt/sources.list.d/gierens.sources \
  && echo "Enabled: yes" >>/etc/apt/sources.list.d/gierens.sources \
  && chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.sources \
  && apt-get update && apt-get install -y eza

CMD ["sleep", "infinity"]