#!/bin/bash
set -e

echo "=== Start Redmine Development Environment ==="

# 環境変数によるリセット処理
if [ "$REDMINE_RESET_ON_START" = "true" ]; then
    echo "REDMINE_RESET_ON_START is enabled. Resetting environment..."
    
    # データベースをリセット
    echo "Dropping database..."
    bundle exec rake db:drop:all RAILS_ENV=development 2>/dev/null || true
    
    # 生成されたファイルを削除
    echo "Removing generated files..."
    rm -f config/database.yml
    rm -f config/configuration.yml
    rm -f config/initializers/secret_token.rb
    rm -f Gemfile.local
    
    # キャッシュとログをクリア
    rm -rf tmp/cache/* 2>/dev/null || true
    rm -f log/*.log 2>/dev/null || true
    
    echo "Reset complete. Now running post_create.sh..."
    # post_create.shを実行して再初期化
    /workspace/.devcontainer/post_create.sh
    
    echo ""
    echo "!!! IMPORTANT !!!"
    echo "Environment has been reset. Please set REDMINE_RESET_ON_START=false"
    echo "in compose.yml to prevent reset on next restart."
    echo ""
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

# Redmine起動
echo "Starting Redmine on http://localhost:3000"
echo "Default credentials: admin / ${ADMIN_PASSWORD}"
exec bundle exec rails server -b 0.0.0.0 -e development