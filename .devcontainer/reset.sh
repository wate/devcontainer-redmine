#!/bin/bash
set -e

echo "=== Resetting Redmine Development Environment ==="

cd /workspace

# オプション処理
RESET_DB=false
if [ "$1" = "--with-db" ]; then
    RESET_DB=true
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

# データベースもリセットする場合
if [ "$RESET_DB" = true ]; then
    echo ""
    echo "Resetting database..."
    bundle exec rake db:drop:all RAILS_ENV=development 2>/dev/null || true
    rm -f config/database.yml
    echo ""
    echo "Database reset complete."
    echo "Run 'Dev Containers: Rebuild Container' to reinitialize everything."
else
    echo ""
    echo "=== Reset complete ==="
    echo ""
    echo "Files cleaned. Database is preserved."
    echo ""
    echo "To also reset the database, run:"
    echo "  .devcontainer/reset.sh --with-db"
    echo ""
    echo "Or rebuild the Dev Container to start fresh."
fi
