#!/bin/bash
set -e

echo "=== Clearing Redmine Development Environment ==="

cd /workspace

# puma プロセスが動いている場合は停止
if pgrep -f "puma.*3000" > /dev/null; then
    echo "Stopping running Redmine server..."
    pkill -f "puma.*3000" || true
    sleep 2
fi

# データベースをリセット（vendor/bundle削除前に実行）
if [ -f config/database.yml ] && [ -d vendor/bundle ]; then
    echo "Dropping and recreating database..."
    bundle exec rake db:drop RAILS_ENV=development 2>/dev/null || true
    bundle exec rake db:create RAILS_ENV=development 2>/dev/null || true
    
    # database.ymlを削除（データベース操作後）
    echo "Removing database.yml..."
    rm -f config/database.yml
    echo ""
fi

# 生成されたファイルを削除
echo "Removing generated files..."
rm -f config/configuration.yml
rm -f config/initializers/secret_token.rb
rm -f Gemfile.local
rm -f Gemfile.lock
rm -f .bundle/config

# vendor/bundleを削除
if [ -d vendor/bundle ]; then
    echo "Removing vendor/bundle..."
    rm -rf vendor/bundle
fi

# tmp/cache を削除
if [ -d tmp/cache ]; then
    echo "Cleaning tmp/cache..."
    rm -rf tmp/cache/*
fi

# log ファイルを削除
if [ -d log ]; then
    echo "Cleaning log files..."
    rm -f log/*.log
fi

echo ""
echo "=== Clear complete ==="
echo ""
echo "Files, caches, logs, and database schema have been cleaned."
echo "To fully reinitialize, run: .devcontainer/reset.sh"
