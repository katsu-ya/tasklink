# TaskLink


![CI / RSpec](https://github.com/katsu-ya/tasklink/actions/workflows/ci.yml/badge.svg)


Rails + Turbo Streamで構築した、チーム向けリアルタイムタスク管理アプリです。

Rails標準技術である Turbo Stream を活用し、SPA化せずに快適なユーザー体験を実現しました。

また、認可・テスト・CI/CD・AWSデプロイまで含め、実務を意識した開発を行いました。

## URL

### Production（AWS EC2）

https://tasklink-app.com

### Demo（Render）

https://tasklink-1iv9.onrender.com

### GitHub

https://github.com/katsu-ya/tasklink

---

## 使用技術

| Category       | Tech                             |
| -------------- | -------------------------------- |
| Backend        | Ruby 3.3 / Rails 8               |
| Frontend       | Turbo / Stimulus / Tailwind CSS  |
| Database       | PostgreSQL                       |
| Authentication | Devise                           |
| Authorization  | Pundit                           |
| Testing        | RSpec                            |
| CI/CD          | GitHub Actions                   |
| Infrastructure | AWS EC2 / Nginx / Puma / systemd |
| Development    | Docker / Docker Compose          |

---

## アプリ概要

TaskLinkは個人・チームで利用できるタスク管理アプリです。

既存のToDoアプリで感じていた、

* ページ更新が多い
* チーム利用を想定していない
* 進捗状況が分かりにくい

といった課題を解決するために開発しました。

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



## 監視・ログ管理

TaskLinkの本番環境では、AWS CloudWatch Agent・CloudWatch Logs・Amazon SNSを利用し、サーバー監視およびログ管理を行っています。

### 構成

```text
EC2 (Rails / Puma / PostgreSQL)
            ↓
     CloudWatch Agent
            ↓
 ┌───────────────┬───────────────┐
 ↓               ↓
CloudWatch    CloudWatch Logs
Metrics
 ↓
CloudWatch Alarm
 ↓
Amazon SNS
 ↓
Email Notification
```

### 監視目的

* ディスク容量不足による障害の予防
* メモリ不足によるアプリケーション停止の予防
* CPU高負荷によるレスポンス低下の早期検知
* 本番環境のログ収集と障害調査の迅速化
* 不正アクセスや異常リクエストの検知

---

### CloudWatchアラーム

| アラーム名                    | 監視内容    | 閾値  |
| ------------------------ | ------- | --- |
| tasklink-disk-usage-80   | ディスク使用率 | 80% |
| tasklink-memory-usage-80 | メモリ使用率  | 80% |
| tasklink-cpu-usage-90    | CPU使用率  | 90% |

#### 収集メトリクス

| メトリクス             | 用途        |
| ----------------- | --------- |
| disk_used_percent | ディスク使用率監視 |
| mem_used_percent  | メモリ使用率監視  |
| cpu_usage_idle    | CPU使用率監視  |

CloudWatch Alarm発生時はAmazon SNSを経由してメール通知を送信し、異常をリアルタイムで検知できる構成としています。

---

### CloudWatch Logs

Rails本番環境ではSTDOUTへ出力されたログをsystemd経由でsyslogへ集約し、CloudWatch Logsへ転送しています。

#### ログ収集フロー

```text
Rails / Puma
     ↓
systemd journal
     ↓
/var/log/syslog
     ↓
CloudWatch Agent
     ↓
CloudWatch Logs
```

#### ロググループ

```text
/tasklink/syslog
```

#### 収集対象

* Railsアクセスログ
* Railsエラーログ
* Puma起動ログ
* systemdログ

---

### 運用上の工夫

運用中に発生したディスク容量不足の障害をきっかけに監視体制を整備しました。

CloudWatch Metricsによるリソース監視とCloudWatch Logsによるログ管理を組み合わせることで、

* 障害の早期発見
* 原因調査の迅速化
* サーバー状態の可視化

を実現しています。

また、ログをCloudWatch Logsへ集約することで、EC2へSSH接続しなくてもAWSコンソール上からログ確認が可能な構成としています。

---

### 今後の改善予定

* CloudWatch Logsのメトリクスフィルターによる500エラー通知
* CloudWatch Dashboardによる可視化
* 障害対応手順（Runbook）の整備
* アプリケーション監視の強化





```
```





---

## 今後の追加機能予定

### 優先度高

* コメント機能
* 通知機能

### 優先度中

* カレンダー表示

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





















