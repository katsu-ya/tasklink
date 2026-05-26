# TaskLink

![CI](https://github.com/katsu-ya/tasklink/actions/workflows/ci.yml/badge.svg)


## URL

### Production (AWS EC2)

https://tasklink-app.com

### Render (Demo)

https://tasklink-1iv9.onrender.com

---

# アプリ概要

TaskLinkは、タスクを直感的に管理できるToDo管理アプリです。

Turbo Streamを活用し、ページ遷移を最小限に抑えながらリアルタイムにUIが更新される構成にしています。

また、

* ドラッグ＆ドロップ
* モーダルUI
* 期限管理
* 達成率表示

など、実務を意識したUI/UXを重視して開発しました。

---

# 作成背景

Rails基礎学習後、

* 「実際に使いたくなるアプリ」
* 「動きで差別化できるポートフォリオ」

を意識して開発しました。

特に、Turbo Streamを利用したリアルタイム更新と、ストレスの少ないUI/UXにこだわっています。

また、インフラ面ではAWS EC2上に本番環境を構築し、Nginx + Puma + systemdによる実運用に近い構成を経験しました。

---

# 使用技術

## Backend

* Ruby 3.3.10
* Rails 8
* PostgreSQL
* Devise
* Kaminari

## Frontend

* Hotwire (Turbo / Stimulus)
* Tailwind CSS
* SortableJS

## Infrastructure

* AWS EC2 (Ubuntu)
* Nginx（リバースプロキシ）
* Puma（Rails Application Server）
* systemd（Puma自動起動）
* PostgreSQL
* Route 53（独自ドメイン）
* Let's Encrypt + Certbot（HTTPS / SSL証明書）
* Elastic IP（固定IP）
* GitHub Actions（CI/CD）
* Dependabot（依存関係アップデート）

---

# ER図

TaskLinkでは、ユーザー単位のタスク管理を中心に、将来的なチーム共有機能まで見据えたデータ設計を行っています。

## データ構造

* User → Task（1対多）
* User ↔ Team（中間テーブル team_users を利用）
* Team → User（多対多）
* Task → Comment（将来的な拡張を想定）

※ 将来的なチーム共有・コメント機能を見据えて設計しています。

## ER図

![ER Diagram](images/er_diagram.png)

### データ構造

* User → Task（1対多）
* User ↔ Team（中間テーブル `team_users` を利用）
* Team → User（多対多）
* Task → Comment（将来的な拡張を想定）

※ 将来的なチーム共有・コメント機能を見据えて設計しています。


![ER図](images/er_diagram.png)

---

# インフラ構成

本番環境はAWS EC2上に構築し、独自ドメイン + HTTPS化に対応しています。

GitHub Actions (CI/CD)

Deploy
→
Browser
→
HTTPS
Nginx (Reverse Proxy)
→
Puma
→
Rails 8 Application
→
PostgreSQL

## 構成のポイント

### Nginx

* リバースプロキシとして動作
* HTTP/HTTPSリクエストをPumaへ転送

### Puma

* Railsアプリケーションサーバー
* systemd管理で自動起動

### systemd

* Pumaのプロセス管理
* EC2再起動後も自動復旧

### Elastic IP

* 固定IP化
* 停止・再起動後もURL変更なし

### HTTPS

* Let's Encrypt + CertbotでSSL化
* HTTP → HTTPSへ自動リダイレクト

---

# 主な機能

## タスク管理

* タスク作成
* タスク編集
* タスク削除
* ステータス変更

  * 未着手
  * 作業中
  * 完了

## 検索・フィルター

* キーワード検索
* ステータス別フィルター
* タスク件数リアルタイム表示

## ドラッグ＆ドロップ

SortableJSを利用し、タスクを直感的に並び替え可能

* 並び替え保存
* ドラッグ中エフェクト
* プレースホルダ表示

## モーダルUI

Turbo Frameを利用し、ページ遷移なしでタスクの作成・編集が可能

* ESCキーで閉じる
* 背景オーバーレイ対応

## 期限管理

* 期限日設定
* 期限切れ表示
* 残り日数表示
* 状況に応じた色分け

### 表示例

* 🔴 期限切れ
* 🟡 今日まで
* 🟢 余裕あり

## 達成率バー

完了タスク割合をリアルタイム可視化

* Turbo Streamによる即時更新
* 進捗率の視覚化

---

# 工夫した点

## Turbo Streamによるリアルタイム更新

タスク作成・更新・削除時に

* タスク一覧
* フィルター件数
* 達成率バー

をページリロードなしで更新しています。

## UI/UXを意識した設計

単に機能を実装するだけではなく、

* 視認性
* 直感的な操作
* ストレスの少なさ

を重視しました。


## AWS本番環境構築 / CI/CD

AWS EC2上にRailsアプリをデプロイし、

* Nginx
* Puma
* systemd
* PostgreSQL

を利用した本番環境を構築しています。

また、独自ドメイン・HTTPS（SSL/TLS）に対応し、安全な通信環境を実現しています。

さらに GitHub Actions を利用し、CI/CD を構築しています。

### CI（自動品質チェック）

GitHub Actions により、push / pull request 時に以下を自動実行しています。

* RuboCop（コード品質チェック）
* bundler-audit（脆弱性チェック）
* Rails Test

これにより、本番反映前にコード品質・セキュリティ・テストを自動検証しています。

### CD（自動デプロイ）

main ブランチへ push 後、自動で EC2 本番環境へデプロイ。

デプロイ時には以下を自動実行しています。

* `bundle install`
* `rails db:migrate`
* `assets:precompile`
* Puma restart（systemd）

コード変更から本番反映までを自動化し、運用負荷を削減しています。

---

## テスト・品質管理

TaskLinkでは、アプリ品質向上のため、Model / Request / System Test を実装しています。

### Model Test

Task / User モデルに対して以下を検証：

* バリデーション
* status enum
* user association
* optional relation
* Request Test

タスク機能の動作・認可・検索を検証：

* タスク作成 / 更新 / 削除
* 未ログイン時のリダイレクト
* 他ユーザー task へのアクセス禁止
* キーワード検索
* status filter
* keyword + status 組み合わせ検索
* invalid params 時の挙動
* System Test

### Capybara + Selenium による E2E テスト：

* タスク作成
* タスク削除
* ステータス変更
* 検索機能
* status filter

### Coverage

SimpleCov を利用しテストカバレッジを可視化。

Line Coverage: 84.21%  


### CI / CD

GitHub Actions により以下を自動化しています。

#### CI

* RuboCop（静的解析）
* bundler-audit（脆弱性チェック）
* Rails Test

#### CD

main ブランチへ push 後、自動で EC2 本番環境へデプロイ。

デプロイ時に以下を自動実行：

* `bundle install`
* `rails db:migrate`
* `assets:precompile`
* Puma restart (`systemd`)
  
---

# テスト戦略

品質担保のため、Model / Request / System Test を実装しています。

## Model Test

バリデーションやモデルの振る舞いを検証しています。

例：

* タスクタイトル必須
* 期限(deadline)の正常系
* deadlineが空でも保存可能
* User作成時のバリデーション

## Request Test

コントローラの責務・認証・権限制御を検証しています。

例：

* タスク作成 / 更新 / 削除
* ログイン必須制御
* 他ユーザーのタスク編集防止
* キーワード検索
* ステータスフィルター
* progress計算のNaN再発防止

## System Test

実際のユーザー操作を想定し、画面挙動を検証しています。

* タスク作成
* 検索
* statusフィルター
* モーダル操作
* 達成率表示

## テスト結果

35 runs, 73 assertions, 0 failures, 0 errors, 0 skips
Coverage: 90.23%

実装だけでなく、品質担保を意識した開発を行っています。




---

# 今後追加したい機能

* タスク通知機能
* タグ機能
* ダークモード
* カレンダー表示
* チーム共有機能
* Docker対応

---

# セットアップ方法

```bash
# clone
git clone https://github.com/katsu-ya/tasklink.git

# move
cd tasklink

# install
bundle install

# database
rails db:create
rails db:migrate

# start
bin/dev
```


# 作者

新城克哉

GitHub:
https://github.com/katsu-ya

---

## 📷 画面イメージ

### タスク一覧

![タスク一覧](images/index.png)

### 新規作成

![新規作成](images/new.png)

### 検索結果（検索ワード）

![検索結果](images/search1.png)

### 検索結果（完了）

![検索結果](images/search2.png)





