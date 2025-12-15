#!/bin/bash
set -e

echo "=== Resetting Redmine Development Environment ==="

cd /workspace

# オプション処理
RESET_DB=true
if [ "$1" = "--preserve-db" ] || [ "$1" = "--without-db" ]; then
    RESET_DB=false
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
    echo "Resetting database schema (keeping database)..."
    bundle exec rake db:migrate VERSION=0 RAILS_ENV=development 2>/dev/null || true
    echo ""
    echo "Database reset complete."
    echo "Run 'Dev Containers: Rebuild Container' to reinitialize everything."
else
    echo ""
    echo "=== Reset complete (database preserved) ==="
    echo ""
    echo "Files cleaned. Database is preserved by option."
    echo ""
    echo "To reset including the database (default behavior), run without options or:"
    echo "  .devcontainer/reset.sh"
    echo ""
    echo "To preserve the database, run:"
    echo "  .devcontainer/reset.sh --preserve-db"
    echo ""
    echo "Or rebuild the Dev Container to start fresh."
fi
