# Debianバージョンを可変に
ARG DEBIAN_VERSION=trixie
FROM debian:${DEBIAN_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

# 本番と同じパッケージ構成
RUN apt-get update && apt-get install -y \
  # Ruby（Debianパッケージ版）
  ruby \
  ruby-dev \
  bundler \
  # ビルドツール
  build-essential \
  # データベースクライアント
  default-libmysqlclient-dev \
  libpq-dev \
  # Redmine依存
  imagemagick \
  libmagickwand-dev \
  # 開発用ツール
  git \
  curl \
  wget \
  vim \
  && rm -rf /var/lib/apt/lists/*

# Redmineユーザー作成
RUN useradd -m -s /bin/bash redmine

WORKDIR /workspace

# 初期化スクリプト
COPY init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

USER redmine

CMD ["/usr/local/bin/init.sh"]