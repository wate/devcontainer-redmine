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

# ~/.my.cnfが存在しない場合は生成
if [ ! -f ~/.my.cnf ]; then
    echo "Generating ~/.my.cnf..."
    cat > ~/.my.cnf <<EOF
[client]
host=${DB_HOST:-db}
user=${DB_USER:-redmine}
password=${DB_PASSWORD:-redmine}
database=${DB_NAME:-redmine}
EOF
    chmod 600 ~/.my.cnf
fi

if [ ! -f Gemfile.local ]; then
    echo "Generating Gemfile.local..."
    cat > Gemfile.local <<EOF
gem "ruby-lsp"
EOF
fi

# configuration.ymlが存在しない場合は生成
if [ ! -f config/configuration.yml ]; then
    echo "Generating config/configuration.yml..."
    cat > config/configuration.yml <<EOF
# Redmine configuration file

production:
  email_delivery:
    delivery_method: :smtp
    smtp_settings:
      address: mailpit
      port: 1025
      domain: localhost

development:
  email_delivery:
    delivery_method: :smtp
    smtp_settings:
      address: mailpit
      port: 1025
      domain: localhost
EOF
fi

# Gemのインストール
echo "Installing gems..."
bundle config set --local path 'vendor/bundle'
bundle install

# シークレットトークンの生成
if [ ! -f config/initializers/secret_token.rb ]; then
    echo "Generating secret token..."
    bundle exec rake generate_secret_token
fi

# データベース初期化
echo "Initializing database..."
bundle exec rake db:migrate RAILS_ENV=development
bundle exec rake redmine:load_default_data REDMINE_LANG=ja RAILS_ENV=development

# プラグインマイグレーション
if [ -n "$(ls -A plugins 2>/dev/null)" ]; then
    echo "Running plugin migrations..."
    bundle exec rake redmine:plugins:migrate RAILS_ENV=development || true
fi

# 開発環境用: 管理者アカウントの設定
echo "Configuring admin user..."
ADMIN_PASSWORD="${REDMINE_ADMIN_PASSWORD:-admin}"
bundle exec rails runner "
  u = User.find_by(login: 'admin')
  u.password = '${ADMIN_PASSWORD}'
  u.password_confirmation = '${ADMIN_PASSWORD}'
  u.must_change_passwd = false
  u.save(validate: false)
  puts 'Admin password configured'
" RAILS_ENV=development
