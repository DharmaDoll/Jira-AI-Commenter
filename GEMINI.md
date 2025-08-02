## Gemini Project Configuration: Jira-AI-Commenter

このファイルは、AIアシスタント Gemini がこのプロジェクトを理解し、効果的に支援するための設定ファイルです。

### Project Overview

Jiraで課題が作成された際にWebhookをトリガーとし、AWS Lambda上で動作するPythonアプリケーションです。EFS上のSQLiteデータベースと連携し、OpenAI APIを利用して文脈に応じたコメントを生成し、指定されたSlackチャンネルに通知することを目的とします。

### Core Technologies

- **Infrastructure as Code:** Terraform
- **Compute:** AWS Lambda (Python)
- **Database:** SQLite on Amazon EFS
- **AI:** OpenAI API (gpt-4)
- **CI/CD:** GitHub Actions
- **Notifications:** Slack Webhook

### Development & Operational Commands

Geminiに指示を出す際に、以下のコマンド体系を参考にしてください。

- **Terraform Commands:**
  - `terraform init`: 初期化
  - `terraform plan`: 変更内容のプレビュー
  - `terraform apply`: 変更の適用
  - `terraform fmt -recursive`: コードのフォーマット

- **Python Dependency Management:**
  - `pip install -r requirements.txt`: 依存ライブラリのインストール
  - `pip freeze > requirements.txt`: 依存関係の更新

- **Local Testing (if using AWS SAM or LocalStack):**
  - `sam build`: SAMアプリケーションのビルド
  - `sam local invoke -e events/jira_issue_created.json`: Lambda関数のローカル実行
  - `awslocal <command>`: LocalStackに対するAWS CLIコマンド
  - **Note:** ローカルテスト用のイベントペイロードは `events/` ディレクトリにJSONファイルとして保存してください。

- **Packaging Lambda Layer:**
  - `bash scripts/build-layer.sh`: Lambdaレイヤーをパッケージ化するスクリプト（要作成）

### Database Schema

このプロジェクトが利用するSQLiteのスキーマは `database/schema.sql` に定義されています。私はこのファイル内の `CREATE TABLE` 文と、各定義に付与された自然言語のコメント（例: `-- description: ...`）を関連付けて解釈することで、データベースの構造と意味を理解し、より精度の高いコードを生成します。

### Secrets Management

このプロジェクトでは、以下のシークレット情報を扱います。これらは **AWS Secrets Manager** で管理することを強く推奨します。コード中にハードコードしないでください。

- `SLACK_WEBHOOK_URL`: Slack通知用のWebhook URL
- `OPENAI_API_KEY`: OpenAI APIキー
- `JIRA_API_TOKEN`: Jira API連携用のトークン（必要な場合）

### Coding Conventions

- **Python:**
  - **Style Guide:** [Black](https://github.com/psf/black) を使用してコードをフォーマットしてください。
  - **Linter:** [Flake8](https://flake8.pycqa.org/en/latest/) または [Ruff](https://github.com/astral-sh/ruff) で静的解析を行ってください。
  - **Typing:** 型ヒントを積極的に利用してください。
- **Terraform:**
  - `terraform fmt -recursive` を実行して、常にコードをフォーマットしてください。
  - `tfsec` や `terrascan` を利用した静的解析を推奨します。

### CI/CD Pipeline (GitHub Actions)

`.github/workflows/` ディレクトリに、以下のようなワークフローを定義することを推奨します。

- **`main`ブランチへのマージ時に自動デプロイ:**
  1. `actions/checkout`
  2. `actions/setup-python`
  3. `aws-actions/configure-aws-credentials`
  4. `hashicorp/setup-terraform`
  5. `pip install -r requirements.txt`
  6. `pytest` でユニットテストを実行
  7. `terraform apply -auto-approve` で本番環境へデプロイ

### Cost Optimization

- **Lambda:** メモリサイズとタイムアウト値を適切に設定し、コストとパフォーマンスのバランスを取ってください。
- **EFS:** Standard-Infrequent Access (Standard-IA) ライフサイクルポリシーを検討し、アクセス頻度の低いデータを低コストで保存してください。
- **CloudWatch:** ログの保存期間を適切に設定してください。

### Security Best Practices

- **Webhook URL:** `spec.md`の通り、推測困難なランダムなパスを使用してください。
- **IAM Roles:** Lambda関数にアタッチするIAMロールは、必要最小限の権限（EFS、Secrets Manager、CloudWatch Logsへのアクセス）のみを許可してください。
- **Dependencies:** `pip-audit` などを利用して、依存ライブラリの脆弱性を定期的にチェックしてください。

### User-defined Instructions

- 私が`出力を保存`と言った場合にはその前の内容を`./tmp/gemini_output.txt`という一時ファイルに保存してください。そして、保存したファイルパスを報告してください。既にファイルが存在する場合は別のファイルに保存してください。ファイル名は一意になるようにして上書きしないでください。
