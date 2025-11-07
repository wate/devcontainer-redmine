#!/bin/bash
set -e

# 色付き出力用
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

REPO_URL="https://raw.githubusercontent.com/wate/redmine-devcontainer/main"

echo -e "${GREEN}=== Redmine Dev Container Installer ===${NC}"
echo ""

# カレントディレクトリがRedmineリポジトリか確認
if [ ! -f "Gemfile" ] || [ ! -d "app" ]; then
    echo -e "${RED}Error: This does not appear to be a Redmine repository.${NC}"
    echo "Please run this script from the root of your Redmine repository."
    exit 1
fi

# .devcontainerディレクトリが既に存在するか確認
if [ -d ".devcontainer" ]; then
    echo -e "${YELLOW}Warning: .devcontainer directory already exists.${NC}"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    rm -rf .devcontainer
fi

# .devcontainerディレクトリを作成
echo "Creating .devcontainer directory..."
mkdir -p .devcontainer

# ファイルをダウンロード
FILES=(
    "devcontainer.json"
    "docker-compose.yml"
    "Dockerfile"
    "init.sh"
)

echo "Downloading Dev Container configuration files..."
for file in "${FILES[@]}"; do
    echo -n "  Downloading ${file}... "
    if curl -sSL -f "${REPO_URL}/.devcontainer/${file}" -o ".devcontainer/${file}"; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
        echo -e "${RED}Error: Failed to download ${file}${NC}"
        exit 1
    fi
done

# init.shに実行権限を付与
chmod +x .devcontainer/init.sh

echo ""
echo -e "${GREEN}=== Installation completed successfully! ===${NC}"
echo ""
echo "Next steps:"
echo "  1. Place your plugins in: plugins/"
echo "  2. Place your themes in: public/themes/"
echo "  3. Open this directory in VS Code: code ."
echo "  4. Command Palette (⌘+Shift+P) → 'Dev Containers: Reopen in Container'"
echo ""
echo "Redmine will be available at: http://localhost:3000"
echo "Default credentials: admin / admin"
echo ""