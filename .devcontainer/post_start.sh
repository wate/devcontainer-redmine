#!/bin/bash
set -e

echo "=== Start Redmine Development Environment ==="

# 起動時にマイグレーションを実行
echo "Running database migrations..."
bundle exec rake db:migrate RAILS_ENV=development

if [ -n "$(ls -A plugins 2>/dev/null)" ]; then
    echo "Running plugin migrations..."
    bundle exec rake redmine:plugins:migrate RAILS_ENV=development || true
fi

# 管理者アカウントの設定（毎回実行）
echo "Configuring admin user..."
ADMIN_PASSWORD="${REDMINE_ADMIN_PASSWORD:-admin}"
bundle exec rails runner "
  u = User.find_by(login: 'admin')
  if u
    u.password = '${ADMIN_PASSWORD}'
    u.password_confirmation = '${ADMIN_PASSWORD}'
    u.must_change_passwd = false
    u.save(validate: false)
    puts 'Admin user configured'
  end
" RAILS_ENV=development 2>/dev/null || true

# REST API設定（毎回実行）
if [ "$REDMINE_REST_API_ENABLED" = "true" ]; then
    echo "Enabling REST API..."
    bundle exec rails runner "
      setting = Setting.find_by(name: 'rest_api_enabled')
      if setting
        setting.value = '1'
        setting.save
        puts 'REST API enabled'
      end
    " RAILS_ENV=development 2>/dev/null || true
fi

# 新規プロジェクトのデフォルト公開設定（環境変数で指定された場合のみ）
if [ -n "$REDMINE_DEFAULT_PROJECTS_PUBLIC" ]; then
    echo "Setting default projects public to: $REDMINE_DEFAULT_PROJECTS_PUBLIC"
    bundle exec rails runner "
      setting = Setting.where(name: 'default_projects_public').first_or_initialize
      setting.value = '${REDMINE_DEFAULT_PROJECTS_PUBLIC}'
      setting.save
      puts 'Default projects public setting updated'
    " RAILS_ENV=development 2>/dev/null || true
fi

# Redmine起動
echo "Starting Redmine on http://localhost:3000"
echo "Default credentials: admin / ${ADMIN_PASSWORD}"
exec bundle exec rails server -b 0.0.0.0 -e development