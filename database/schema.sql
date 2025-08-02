-- このファイルは、Jira-AI-Commenterが使用するSQLiteデータベースのスキーマを定義します。
-- 各テーブルやカラムには、LLMがその意味を理解するための説明コメントを付与しています。

-- FAQテーブル: Jira課題に関連するよくある質問と回答テンプレートを格納します。
CREATE TABLE faqs (
    id INTEGER PRIMARY KEY, -- description: レコードの一意なID
    category TEXT NOT NULL, -- description: 質問のカテゴリ（例: '仕様', 'バグ', 'アカウント'）
    keywords TEXT NOT NULL, -- description: Jira課題の本文と照合するためのキーワード。カンマ区切りで複数指定可能。
    answer_template TEXT NOT NULL -- description: Slackに通知する回答のテンプレート文章。{issue_key}のようなプレースホルダーを含めることができる。
);

-- 担当者テーブル: 課題カテゴリごとのエスカレーション先担当者を管理します。
CREATE TABLE assignments (
    id INTEGER PRIMARY KEY,
    category TEXT NOT NULL UNIQUE, -- description: FAQテーブルのカテゴリと対応する。
    slack_user_id TEXT NOT NULL -- description: メンションするSlackのユーザーID（例: 'U12345ABC'）
);
