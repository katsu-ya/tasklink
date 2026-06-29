# TaskLink


![CI / RSpec](https://github.com/katsu-ya/tasklink/actions/workflows/ci.yml/badge.svg)


📌 TaskLink

Rails + Turbo Streamで構築した、チーム向けタスク管理アプリです。
SPAを使わずにリアルタイムUI更新を実現し、実務レベルの開発・運用（CI/CD・AWS・監視）まで一貫して構築しています。

---

🚀 Demo / Links
* 🌐 Production（AWS）
https://tasklink-app.com
* 🧪 Demo（Render）
https://tasklink-1iv9.onrender.com
* 💻 GitHub
https://github.com/katsu-ya/tasklink

---

🧠 Why I Built This

従来のToDoアプリの課題：

* ページ更新が多くUXが悪い
* チーム利用を想定していない
* 進捗が直感的に分からない

👉 これらを解決するために開発

---



⚙️ Tech Stack
Category	Tech
Backend	Ruby 3.3 / Rails 8
Frontend	Turbo / Stimulus / Tailwind CSS
DB	PostgreSQL
Auth	Devise
Authorization	Pundit
Test	RSpec
CI/CD	GitHub Actions
Infra	AWS EC2 / Nginx / Puma / systemd
Dev	Docker / Docker Compose

---



📌 Features

📋 Task Management
* タスク作成 / 編集 / 削除
* ステータス管理（Todo / Doing / Done）
* 期限管理
* 達成率表示
  
🔍 Search / Filter
* キーワード検索
* ステータスフィルタ
* 件数リアルタイム更新

💬 Collaboration
* コメント機能（※予定 or 実装状況に合わせて調整）
* いいね機能

⚡ Real-time UX 
* Turbo Streamによる非同期更新
* Turbo FrameモーダルUI
* SortableJSによる並び替え

---



## 📷 画面イメージ

### タスク一覧画面

![タスク一覧画面](images/index.png)

### タスク作成モーダル

![タスク作成モーダル](images/new.png)

### 検索結果画面（キーワード）

![検索結果画面（キーワード）](images/search1.png)

### 検索結果画面（完了タスク）

![検索結果画面（完了タスク）](images/search2.png)

### スマホ表示

![スマホ表示](images/smartphone.png)

---



## 主な機能

### タスク管理

* タスク作成・編集・削除
* ステータス管理（Todo / Doing / Done）
* 期限管理
* 達成率表示

### 検索・フィルター

* キーワード検索
* ステータス別フィルター
* 件数のリアルタイム更新

### UI / UX

* Turbo Streamによるリアルタイム更新
* Turbo Frameを利用したモーダルUI
* SortableJSによるドラッグ＆ドロップ並び替え
* レスポンシブ対応

### セキュリティ

* Deviseによる認証
* Punditによるチーム単位の認可
* 他チームのタスクへのアクセス制御

---



## 工夫した点

### 1. Turbo Streamによるリアルタイム更新

タスクの作成・更新・削除時に、

* タスク一覧
* 達成率バー
* フィルター件数

をページリロードなしで更新しています。

SPAを導入せずにユーザー体験を向上させることを意識しました。

### 2. Punditによる認可

認証だけではURL直接アクセスを防げないため、Punditを導入しました。

* policy_scopeによる取得制御
* TaskPolicyによる閲覧・編集・削除制御

を実装し、チーム単位で安全にデータを管理できるようにしています。

### 3. 実運用を意識したインフラ構築

本番環境をAWS EC2上に構築しました。

* Nginx
* Puma
* systemd
* PostgreSQL

を利用し、HTTPS化および独自ドメイン運用に対応しています。

---



## ER Diagram

将来的なチーム共有機能・コメント機能まで見据えて設計しています。

![ER Diagram](images/er_diagram.png)


---

## インフラ構成

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

### 構成ポイント

* GitHub Actionsによる自動デプロイ
* systemdによるPumaプロセス管理
* Let's EncryptによるHTTPS対応
* Elastic IPによる固定IP運用

---

## CI/CD

GitHub Actionsを利用し、mainブランチへのPush時に以下を自動実行しています。

### CI

* RSpec
* RuboCop
* bundler-audit

### CD

* bundle install
* rails db:migrate
* assets:precompile
* Puma restart



---

## テスト

RSpecを用いてテストを実装しています。

### テスト対象

* Model Spec
* Request Spec
* 認証
* 認可
* CRUD処理
* 検索・フィルター

### Coverage

約75%



---

## 開発環境

Docker Composeを利用し、RailsとPostgreSQLの開発環境を構築しています。

### 起動

```bash
docker compose build
docker compose up
```

### DB作成

```bash
docker compose run web rails db:create
docker compose run web rails db:migrate
```

---

## 苦労した点

チーム機能追加時に、本番環境の既存データに team_id が存在しない問題が発生しました。

Rails consoleを利用して原因を特定し、

* マイグレーション修正
* データ移行

を行うことで解決しました。

データベース変更時の既存データへの影響について学ぶことができました。



---





# インフラ・監視運用

TaskLinkでは AWS を利用し、本番環境の監視・ログ管理・障害通知・HTTPS化を実装しています。

## 構成

```text
Internet
    ↓
Route53
    ↓
ALB (HTTPS / ACM)
    ↓
EC2 (Nginx)
    ↓
Puma
    ↓
Rails
    ↓
PostgreSQL

          ┌────────────────────┐
          │ CloudWatch Agent   │
          └─────────┬──────────┘
                    ↓
      CloudWatch Metrics / Logs
                    ↓
            CloudWatch Alarm
                    ↓
               Amazon SNS
                    ↓
           Email Notification
```

## 監視・ログ管理

CloudWatch Agent を利用してサーバーメトリクスおよびログを収集しています。

### 監視対象

* ディスク使用率
* メモリ使用率
* CPU使用率
* Pumaプロセス死活監視
* Rails 500エラー

### 通知

CloudWatch Alarm と Amazon SNS を連携し、異常検知時にメール通知を送信しています。

### ログ管理

Rails / Puma ログを CloudWatch Logs に集約し、CloudWatch Logs Insights によるログ分析を可能にしています。

主な分析内容

* Rails 500エラー分析
* アクセスログ分析
* IPアドレス別アクセス集計
* 不正アクセス検知

## 可視化

CloudWatch Dashboard を利用し、以下を一画面で監視しています。

* Disk Usage
* Memory Usage
* CPU Usage
* Rails 500 Errors

障害発生時の状況把握と原因調査を迅速に行える構成としています。

## HTTPS対応

Application Load Balancer（ALB）および AWS Certificate Manager（ACM）を利用し HTTPS 化を実施しています。

### 実装内容

* ALB構築
* Target Group作成
* Health Check設定
* ACM証明書発行
* Route53連携
* HTTPSリスナー設定

### 利用サービス

* Application Load Balancer (ALB)
* AWS Certificate Manager (ACM)
* Route53

### 導入効果

* SSL証明書の自動更新
* HTTPS通信の実現
* 可用性向上
* 将来的なAuto Scalingへの対応

## 運用改善

運用中に発生したディスク容量不足の障害をきっかけに監視体制を整備しました。

実施内容

* CloudWatch Agent導入
* CloudWatch Logs集約
* SNS通知構築
* Rails 500エラー監視
* Puma死活監視
* CloudWatch Dashboard作成
* Runbook整備
* CloudWatch Logs Insightsによるログ分析

これにより、

* 障害の早期発見
* 原因調査の迅速化
* サーバー状態の可視化

を実現しています。

## 今後の改善

* CloudWatch Logs Insightsによる分析強化
* アプリケーション監視の高度化
* Auto Scaling対応
* 監視ダッシュボード改善

```
```

### EBS容量拡張による運用改善

CloudWatchによるディスク使用率監視でアラームが発報したため、
Linuxコマンド（df / du）を用いて容量調査を実施。

調査結果をもとに、AWS EBSボリュームを8GBから20GBへ拡張し、
growpart・resize2fsを利用してオンラインでファイルシステムを拡張した。

#### 対応内容

- CloudWatch Alarmによる検知
- Linux容量調査（df, du）
- EBSオンライン拡張
- パーティション拡張（growpart）
- ファイルシステム拡張（resize2fs）

#### 結果

- ディスク使用率: 81% → 30%
- 空き容量: 1.4GB → 13GB
- アラーム解消




---



## 今後の追加機能予定

### 優先度高

* コメント機能
* 通知機能

### 優先度中

* カレンダー表示
* 優先順位

### 優先度低

* ダークモード

---

## 作者

新城 克哉

GitHub
https://github.com/katsu-ya

Qiita
https://qiita.com/katsu-ya


---





















