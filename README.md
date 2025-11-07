Redmine Dev Container
=========================

Debian + システムRubyで本番環境を忠実に再現したRedmine開発環境のDev Container設定です。

特徴
-------------------------

- ✅ **本番環境再現**: DebianのシステムRubyを使用
- ✅ **ワンライナーインストール**: 1コマンドで設定完了
- ✅ **自動セットアップ**: database.yml生成、gem install、DB migration自動実行
- ✅ **ソースコード解析**: VS Code上でRubyの定義ジャンプ、コード補完
- ✅ **バージョン切り替え**: `git checkout`で簡単にRedmineバージョン変更
- ✅ **プラグイン/テーマ検証**: 本番環境と同じ構成で動作確認

クイックスタート
-------------------------

```bash
# 1. Redmineをクローン
git clone https://github.com/redmine/redmine.git
cd redmine

# 2. 使いたいバージョンにチェックアウト
git checkout 6.1-stable

# 3. Dev Container設定をインストール（ワンライナー）
curl -sSL https://raw.githubusercontent.com/wate/redmine-devcontainer/main/install.sh | bash

# 4. プラグイン・テーマを配置（任意）
cp -r /path/to/your/plugin plugins/
cp -r /path/to/your/theme public/themes/

# 5. VS Codeで開く
code .

# 6. コマンドパレット（⌘+Shift+P）から
# "Dev Containers: Reopen in Container" を選択
```

初回起動は5-10分かかります（イメージビルド、gem install等）。

起動後、http://localhost:3000 にアクセス:

- ユーザー名: `admin`
- パスワード: `admin`

インストール方法
-------------------------

### 方法1: curl（推奨）

```bash
cd /path/to/redmine
curl -sSL https://raw.githubusercontent.com/wate/redmine-devcontainer/main/install.sh | bash
```

### 方法2: 手動インストール

```bash
cd /path/to/redmine
git clone --depth 1 https://github.com/wate/redmine-devcontainer.git /tmp/devcontainer-temp
cp -r /tmp/devcontainer-temp/.devcontainer .
rm -rf /tmp/devcontainer-temp
chmod +x .devcontainer/init.sh
```

### 方法3: GitHub CLI

```bash
cd /path/to/redmine
gh repo clone wate/redmine-devcontainer /tmp/devcontainer-temp -- --depth 1
cp -r /tmp/devcontainer-temp/.devcontainer .
rm -rf /tmp/devcontainer-temp
chmod +x .devcontainer/init.sh
```

構成
-------------------------

- **OS**: Debian (デフォルト: Trixie)
- **Ruby**: システムRuby（Debianパッケージ版）
- **Database**: MariaDB 11
- **Bundler**: システムbundler

使い方
-------------------------

### プラグインの追加

```bash
# ホスト側（Mac）でプラグインを追加
cp -r /path/to/new_plugin plugins/

# VS Codeのターミナルで（コンテナ内）
bundle install
bundle exec rake redmine:plugins:migrate RAILS_ENV=development

# Railsサーバーを再起動（Ctrl+C → init.sh再実行）
```

### Redmineバージョンの切り替え

```bash
# ホスト側（Mac）で
git checkout 5.1-stable

# VS Codeで
# コマンドパレット → "Dev Containers: Rebuild Container"
```

### Debianバージョンの変更

`.devcontainer/docker-compose.yml`を編集

```yaml
services:
  redmine:
    build:
      context: .
      dockerfile: Dockerfile
      args:
        DEBIAN_VERSION: bookworm  # trixie, bookworm, bullseye等
```

または環境変数で指定

```bash
# ホスト側（Mac）で
export DEBIAN_VERSION=bookworm
# VS Code: "Dev Containers: Rebuild Container"
```

### データベースのリセット

```bash
# コンテナ内で
RESET_DB=true /usr/local/bin/init.sh
```

### PostgreSQLを使う場合

`.devcontainer/docker-compose.yml`を編集

```yaml
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: redmine
      POSTGRES_USER: redmine
      POSTGRES_PASSWORD: redmine
    # ...

  redmine:
    environment:
      DB_ADAPTER: postgresql
      # ...
```

トラブルシューティング
-------------------------

### コンテナが起動しない

```bash
# コンテナを完全に削除して再構築
docker compose -f .devcontainer/docker-compose.yml down -v
# VS Code: "Dev Containers: Rebuild Container"
```

### gemのインストールに失敗

```bash
# コンテナ内で
rm -rf vendor/bundle
bundle install
```

### プラグインがロードされない

```bash
# プラグインディレクトリの確認
ls -la plugins/

# プラグインのマイグレーション
bundle exec rake redmine:plugins:migrate RAILS_ENV=development
```

本番環境との差異
-------------------------

### 同じ点

- DebianのシステムRuby
- MariaDB/PostgreSQL
- ディレクトリ構造（/workspace）
- bundlerの設定

### 異なる点

- systemdが動かない（コンテナの制約）
- Nginx/Apacheがない
- SSL証明書がない
- Apple Silicon（ARM64）での実行（本番はx86_64の可能性）

**完全な検証はVM環境（Vagrant、クラウドインスタンス等）で実施してください。**

貢献
-------------------------

Issue、Pull Requestを歓迎します。

参考
-------------------------

- [Redmine公式サイト](https://www.redmine.org/)
- [Redmine GitHub](https://github.com/redmine/redmine)
- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
