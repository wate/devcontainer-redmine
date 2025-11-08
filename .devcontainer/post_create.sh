#!/bin/bash
set -e

echo "=== Initializing Redmine Development Environment ==="

cd /workspace

# database.ymlが存在しない場合は生成
if [ ! -f config/database.yml ]; then
    echo "Generating config/database.yml..."
    cat > config/database.yml <<EOF
production:
  adapter: ${DB_ADAPTER:-mysql2}
  database: ${DB_NAME:-redmine}
  host: ${DB_HOST:-db}
  username: ${DB_USER:-redmine}
  password: ${DB_PASSWORD:-redmine}
  encoding: utf8mb4

development:
  adapter: ${DB_ADAPTER:-mysql2}
  database: ${DB_NAME:-redmine}
  host: ${DB_HOST:-db}
  username: ${DB_USER:-redmine}
  password: ${DB_PASSWORD:-redmine}
  encoding: utf8mb4
EOF
fi

if [ ! -f Gemfile.local ]; then
    echo "Generating Gemfile.local..."
    cat > Gemfile.local <<EOF
gem "puma"
gem "ruby-lsp"
EOF
fi

# Gemのインストール
echo "Installing gems..."
bundle config set --local without 'test'
bundle config set --local path 'vendor/bundle'
bundle install

# データベース初期化（初回のみ）
echo "Checking database..."
if ! bundle exec rails runner "ActiveRecord::Base.connection" 2>/dev/null; then
    echo "Initializing database..."
    bundle exec rake db:migrate RAILS_ENV=development
    bundle exec rake redmine:load_default_data REDMINE_LANG=ja RAILS_ENV=development
fi

# プラグインマイグレーション
if [ -n "$(ls -A plugins 2>/dev/null)" ]; then
    echo "Running plugin migrations..."
    bundle exec rake redmine:plugins:migrate RAILS_ENV=development || true
fi
