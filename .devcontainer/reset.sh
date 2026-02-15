#!/bin/bash
set -e

echo "=== Resetting Redmine Development Environment ==="

cd /workspace

DUMP_FILE="./.devcontainer/db_dump.sql"
PRESERVE_REQUESTED=false

# 引数解析
while [[ $# -gt 0 ]]; do
    case "$1" in
        --preserve)
            PRESERVE_REQUESTED=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--preserve]"
            exit 1
            ;;
    esac
done

# データベースダンプ（--preserve 指定時）
if [[ "$PRESERVE_REQUESTED" == true ]]; then
    echo "Backing up database..."
    mysqldump \
        -h "$DB_HOST" \
        -u "$DB_USER" \
        -p"$DB_PASSWORD" \
        "$DB_NAME" > "$DUMP_FILE"
    echo "Database backed up to $DUMP_FILE"
    echo ""
fi

# キャッシュとファイルをクリア
./.devcontainer/clear.sh

# 環境を再初期化
echo ""
echo "Reinitializing environment..."
./.devcontainer/post_create.sh

echo ""
echo "=== Reset complete ==="

# ダンプファイルが存在する場合は自動的にリストア
if [[ -f "$DUMP_FILE" ]]; then
    echo "Restoring database from $DUMP_FILE..."
    mysql \
        -h "$DB_HOST" \
        -u "$DB_USER" \
        -p"$DB_PASSWORD" \
        "$DB_NAME" < "$DUMP_FILE"
    echo "Database restored"
    echo ""
fi

echo "Starting Redmine server..."
exec ./.devcontainer/post_start.sh
