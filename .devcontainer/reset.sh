#!/bin/bash
set -e

echo "=== Resetting Redmine Development Environment ==="

cd /workspace

# キャッシュとファイルをクリア
./.devcontainer/clear.sh

# 環境を再初期化
echo ""
echo "Reinitializing environment..."
./.devcontainer/post_create.sh

echo ""
echo "=== Reset complete ==="
echo ""
echo "Starting Redmine server..."
exec ./.devcontainer/post_start.sh
