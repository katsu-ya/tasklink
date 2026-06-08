# TaskLink

![CI](https://github.com/katsu-ya/tasklink/actions/workflows/ci.yml/badge.svg)


## URL

### Production (AWS EC2)

https://tasklink-app.com

### Render (Demo)

https://tasklink-1iv9.onrender.com

---

# アプリ概要

TaskLinkは、Turbo Streamを活用したリアルタイム更新対応のToDo管理アプリです。

Rails学習後、単なるCRUDアプリではなく、

- Turbo Streamによるリアルタイム更新
- Docker環境構築
- AWS本番運用
- GitHub Actions
- Pundit認可

まで含めた、

実務を意識したアプリ開発を目的として作成しました。

---

## 制作背景

TaskLinkは個人・チームで利用できるタスク管理アプリです。

既存のToDoアプリでは、
・進捗状況が把握しづらい
・ページ更新が多い
・複数人での利用を想定していない

という課題を感じ、

Turbo Streamによるリアルタイム更新と
チーム単位のアクセス制御を実装しました。

---

## 技術的な挑戦

- Turbo Streamによるリアルタイム更新
- Punditによるチーム単位認可
- GitHub ActionsによるCI/CD
- AWS EC2への本番デプロイ
- Dockerによる開発環境統一

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


---

## 苦労した点

チーム機能追加時に既存データの移行が必要になり、
本番環境で team_id が設定されていない問題が発生しました。

Rails console を用いて原因を特定し、
マイグレーションとデータ移行を行って解決しました。

---



## 💡 工夫した点

### Turbo Streamによるリアルタイム更新

タスク作成・更新・削除時に、

- タスク一覧
- 達成率バー
- フィルター件数

をページリロードなしで更新。

### UI/UXを意識した設計

- モーダルUI
- ドラッグ＆ドロップ
- 期限状態の色分け
- 視認性を意識したデザイン


### Punditによる認可

認証だけではURLを直接指定した場合に
他人のタスクへアクセスできる可能性があるため、

Punditを導入し、
サーバーサイドで権限制御を実装しました。


### Error Handling

異常系のUXも考慮し、404 / 500 カスタムエラーページを実装しています。

404 Not Found

存在しないURLへアクセスした場合、ユーザーが迷わないようにエラーページを表示し、タスク一覧へ戻れる導線を用意しています。

500 Internal Server Error

サーバ内部エラー発生時にも専用ページを表示し、ユーザー体験を損なわない構成にしています。

- カスタム404ページ
- カスタム500ページ
- タスク一覧へ戻る導線
- 異常系UXを考慮した設計


### 実運用を意識したインフラ構築

AWS EC2上に、

- Nginx
- Puma
- systemd
- PostgreSQL

を構築。

独自ドメイン + HTTPS にも対応。


## 使用技術

| Category | Tech |
|---|---|
| Backend | Ruby 3.3 / Rails 8 |
| Frontend | Turbo / Stimulus / Tailwind |
| DB | PostgreSQL |
| Infra | AWS EC2 / Nginx / Puma |
| CI/CD | GitHub Actions |




## Docker

Docker Compose を利用し、
Rails + PostgreSQL の開発環境をコンテナ化しています。

### 起動

docker compose build
docker compose up

### DB

docker compose run web rails db:create
docker compose run web rails db:migrate

### 構成

web (Rails 8 / Puma)
db (PostgreSQL 16)

### 工夫

- 開発環境差異の削減
- 再現性の高い環境構築
- .dockerignore による軽量化






## ER Diagram

将来的なチーム共有機能・コメント機能まで見据えて設計しています。

![ER Diagram](images/er_diagram.png)




---


## Infrastructure

```bash
GitHub Actions
↓
AWS EC2
↓
Nginx
↓
Puma
↓
Rails
↓
PostgreSQL
```

- HTTPS対応
- 独自ドメイン対応
- systemdによるPuma常駐化





## 構成ポイント

### Nginx

- リバースプロキシとして動作
- HTTP/HTTPSリクエストをPumaへ転送

### Puma

- Railsアプリケーションサーバー
- systemd管理で自動起動

### systemd

- Pumaのプロセス管理
- EC2再起動後も自動復旧

### Elastic IP

- 固定IP化
- 停止・再起動後もURL変更なし

### HTTPS

- Let's Encrypt + CertbotでSSL化
- HTTP → HTTPSへ自動リダイレクト

---


# 主な機能

## タスク管理

- タスク作成
- タスク編集
- タスク削除
- ステータス変更

  - 📝 未着手（todo）
  - 🔥 作業中（doing）
  - ✅ 完了（done）

## 検索・フィルター

- キーワード検索
- ステータス別フィルター
- タスク件数リアルタイム表示

## ドラッグ＆ドロップ

SortableJSを利用し、タスクを直感的に並び替え可能

- 並び替え保存
- ドラッグ中エフェクト
- プレースホルダ表示

## モーダルUI

Turbo Frameを利用し、ページ遷移なしでタスクの作成・編集が可能

- ESCキーで閉じる
- 背景オーバーレイ対応

## 期限管理

- 期限日設定
- 期限切れ表示
- 残り日数表示
- 状況に応じた色分け

### 表示例

- 🔴 期限切れ
- 🟡 今日まで
- 🟢 余裕あり

## 達成率バー

完了タスク割合をリアルタイム可視化

- Turbo Streamによる即時更新
- 進捗率の視覚化

---





## Development Environment

- Docker
- Docker Compose
- Makefile



---



## テスト / 品質保証

RSpecを用いて Model Spec / Request Spec を実装しています。

### 主なテスト

* Taskモデルのバリデーション
* タスクCRUD
* 認証（未ログイン時のリダイレクト）
* 認可（他ユーザーのタスク編集防止）
* ステータス更新
* 検索 / フィルター

* Coverage：約72%
* CI：GitHub Actions
* Deploy：AWS EC2



## CI/CD

GitHub Actions を利用して
自動テスト・自動デプロイを構築しています。

### CI

- RSpec
- RuboCop
- bundler-audit

### CD

mainブランチへPush時

- bundle install
- db:migrate
- assets:precompile
- Puma restart

を自動実行し EC2へデプロイ





## Authorization (Pundit)

Pundit を利用し、
チーム単位でアクセス制御を実装しています。

### 実装内容

- policy_scope によるデータ取得制御
- TaskPolicy による閲覧・編集・削除制御
- 他チームのタスクへアクセス不可
- タスク作成時に所属チームを自動付与

### 使用技術

- Devise（認証）
- Pundit（認可）
- RSpec（認可テスト）

### BulletによるN+1検知

Bulletを導入し、開発中にN+1クエリを検知できるようにしています。

タスク一覧表示時に発生していた

* Task → User
* Task → Team

の関連取得を改善し、

```ruby
includes(:user, :team)
```

を利用してクエリ数を最適化しました。







---

## 今後追加したい機能

- チーム共有機能
- コメント機能
- 通知機能
- カレンダー表示
- ダークモード

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





















