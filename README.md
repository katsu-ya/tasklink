# TaskLink

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

# インフラ構成

本番環境はAWS EC2上に構築し、独自ドメイン + HTTPS化に対応しています。

GitHub Actions (CI/CD)
↓
Deploy
↓
Browser
↓ HTTPS
Nginx (Reverse Proxy)
↓
Puma
↓
Rails 8 Application
↓
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

### CI/CD

GitHub Actions により以下を自動化しています。

* Rubocop
* Rails Test
* EC2 自動デプロイ

#### CI

* RuboCop（コード品質チェック）
* bundler-audit（脆弱性チェック）
* Rails Test

#### CD

main ブランチへ push 後、自動で EC2 本番環境へデプロイ。

デプロイ時に以下を自動実行：

* `bundle install`
* `rails db:migrate`
* `assets:precompile`
* Puma restart (`systemd`)

これにより、コード変更後の本番反映を自動化しています。

## テスト・品質管理

TaskLinkでは、アプリ品質向上のために、テスト・静的解析・CI/CD を導入しています。

また、Model / Request / System Test を実装し、バリデーション・認可・実際の画面操作まで含めて検証できる構成にしています。


### Test Coverage

SimpleCov を利用し、テストカバレッジを可視化しています。

* Coverage: 78.29%
  
### 実施テスト

Taskモデルに対して以下を検証しています。

* title 必須バリデーション
* user 必須バリデーション
* status enum の動作確認
* team optional の確認
  
### Request Test

タスク機能の動作と認可をテストしています。

* /tasks アクセス確認
* 未ログイン時のリダイレクト
* タスク作成成功
* タスク更新成功
* 不正パラメータ時の失敗
* タスク削除成功
* 他ユーザー task へのアクセス禁止

### System Test

Capybara を利用し、実際のブラウザ操作を伴うテストを実施しています。

現在は以下を自動テストしています。

* ログイン
* タスク作成
* 作成後の画面表示確認

### Coverage

SimpleCov を導入し、テストカバレッジを可視化しています。

例：

* Line Coverage: 58%+

CI（GitHub Actions）上でもテストが自動実行される構成にしています。


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





