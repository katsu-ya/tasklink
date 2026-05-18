# TaskLink

## URL

### AWS EC2 (Production)

http://54.248.41.247

### Render

https://tasklink-1iv9.onrender.com

---

# アプリ概要

TaskLinkは、タスクを直感的に管理できるToDo管理アプリです。

Turbo Streamを活用し、ページ遷移を減らしながらリアルタイムにUIが更新される構成にしています。

また、ドラッグ＆ドロップ、期限管理、達成率表示など、実務を意識したUI/UXを重視しています。

---

# 作成背景

Railsの基礎学習後、

* 「実際に使いたくなるアプリ」
* 「動きで差別化できるポートフォリオ」

を意識して開発しました。

特にTurbo Streamを使用したリアルタイム更新と、ストレスの少ないUI/UXにこだわっています。

また、AWS EC2 + Nginx + Puma + PostgreSQL を用いて、本番環境構築まで行いました。

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

---

## Server Architecture

Browser
   ↓ HTTPS 
Nginx (Reverse Proxy) 
   ↓ 
Puma 
   ↓ 
Rails 8 Application 
   ↓ 
PostgreSQL

---

# 主な機能

## タスク管理

* タスクの作成
* タスクの編集
* タスクの削除
* ステータス変更

  * 未着手
  * 作業中
  * 完了

---

## 検索・フィルター

* キーワード検索
* ステータス別フィルター
* タスク件数のリアルタイム表示

---

## ドラッグ＆ドロップ

SortableJSを利用し、タスクを直感的に並び替え可能にしました。

* 並び替えの保存
* ドラッグ中エフェクト
* プレースホルダ表示

---

## モーダルUI

Turbo Frameを使用し、ページ遷移なしでタスクの作成・編集が可能です。

* ESCキーでモーダルを閉じる
* 背景オーバーレイ対応

---

## 期限管理

* 期限日設定
* 期限切れ表示
* 残り日数表示
* 期限に応じた色分け

### 表示例

* 🔴 期限切れ
* 🟡 今日まで
* 🟢 余裕あり

---

## 達成率バー

完了タスクの割合をリアルタイムで可視化しています。

* Turbo Streamによる即時更新
* 進捗率を視覚的に表示

---

## アニメーション

* ホバーエフェクト
* タスク作成時ハイライト
* 完了時の紙吹雪エフェクト

---

# 工夫した点

## Turbo Streamを使ったリアルタイム更新

タスクの作成・更新・削除時に、

* タスク一覧
* フィルター件数
* 達成率バー

をページリロードなしで更新しています。

---

## UI/UXを意識した設計

単に機能を実装するだけではなく、

* 視認性
* 操作の直感性
* ストレスの少なさ

を重視しました。

---

## AWS本番環境構築

AWS EC2上にRailsアプリをデプロイし、

* Nginx
* Puma
* systemd
* PostgreSQL

を使用した本番環境構築を行いました。

また、systemdを利用してPumaを常駐化し、サーバ再起動時にも自動起動する構成にしています。

さらに Elastic IP を設定し、停止・再起動後も同じURLでアクセス可能な環境を構築しています。

---

# 構成のポイント

* Nginx
    リバースプロキシとして動作
    HTTPリクエストを Puma に転送
* Puma
    Railsアプリケーションサーバー
    systemd 管理で自動起動
* systemd
    Puma のプロセス管理
    EC2再起動後も自動復旧
* Elastic IP
    固定IP化によりURL変更なしでアクセス可能

# 今後追加したい機能

* HTTPS化（SSL対応）
* 独自ドメイン対応
* タスク通知機能
* タグ機能
* ダークモード
* カレンダー表示
* チーム共有機能
* GitHub Actionsによる自動デプロイ

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

---

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







