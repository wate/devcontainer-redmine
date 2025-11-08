#!/bin/bash
set -e

echo "=== Start Redmine Development Environment ==="

# Redmine起動
echo "Starting Redmine on http://localhost:3000"
echo "Default credentials: admin / admin"
exec bundle exec rails server -b 0.0.0.0 -e development